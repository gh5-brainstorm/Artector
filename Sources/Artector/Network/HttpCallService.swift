//
//  HttpCallService.swift
//
//
//  Created by danny santoso on 7/12/24.
//

import Foundation

/// A singleton class responsible for making HTTP requests.
final class HttpCallService {
    
    /// Shared instance of `HttpCallService`.
    static let sharedInstance = HttpCallService()
    
    /// Private initializer to prevent outside initialization.
    private init() {}
    
    /// Makes an HTTP request without sending any data.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method for the request.
    ///   - callback: A closure to be called upon completion of the request, containing the status code and response data.
    func request<T: Decodable>(
        url: String,
        method: String,
        _ callback: @escaping (Int, T?, URLError?) -> Void
    ) {
        self.processRequest(url: url, method: method, data: nil, callback)
    }
    
    /// Makes an HTTP request with the specified data.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method for the request.
    ///   - data: The data to be sent with the request.
    ///   - callback: A closure to be called upon completion of the request, containing the status code and response data.
    func request<T: Decodable>(
        url: String,
        method: String,
        data: [String: Any]?,
        _ callback: @escaping (Int, T?, URLError?) -> Void
    ) {
        self.processRequest(url: url, method: method, data: data, callback)
    }
    
    /// Processes an HTTP request.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method for the request.
    ///   - data: The data to be sent with the request.
    ///   - callback: A closure to be called upon completion of the request, containing the status code and response data.
    private func processRequest<T: Decodable>(
        url: String,
        method: String,
        data: [String: Any]?,
        _ callback: @escaping (Int, T?, URLError?) -> Void
    ) {
        guard let url = URL(string: url) else {
            callback(400, nil, .customError("Invalid URL"))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let data = data {
            request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                callback(500, nil, .customError(error?.localizedDescription))
                return
            }

            guard let data = data else {
                callback(httpResponse.statusCode, nil, .customError(error?.localizedDescription))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(HttpResponse<T>.self, from: data)
                callback(httpResponse.statusCode, decodedResponse.data, nil)
            } catch {
                callback(httpResponse.statusCode, nil, .customError(error.localizedDescription))
            }
        }
        task.resume()
    }
    
    /// Uploads an image.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - imageData: The image data to be uploaded.
    ///   - callback: A closure to be called upon completion of the request, containing the status code and response data.
    func uploadImage<T: Decodable>(
        url: String,
        filePath: String,
        _ callback: @escaping (Int, T?, URLError?) -> Void
    ) {
        guard let url = URL(string: url) else {
            callback(400, nil, .customError("Invalid URL"))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        // Add the file data to the request body
        do {
            let fileData = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let boundaryPrefix = "--\(boundary)\r\n"
            let disposition = "Content-Disposition: form-data; name=\"files\"; filename=\"\(filePath.lastPathComponent)\"\r\n"
            let contentType = "Content-Type: image/jpeg\r\n\r\n"
            let boundarySuffix = "\r\n--\(boundary)--\r\n"
            
            if let boundaryPrefixData = boundaryPrefix.data(using: .utf8),
               let dispositionData = disposition.data(using: .utf8),
               let contentTypeData = contentType.data(using: .utf8),
               let boundarySuffixData = boundarySuffix.data(using: .utf8) {
                
                body.append(boundaryPrefixData)
                body.append(dispositionData)
                body.append(contentTypeData)
                body.append(fileData)
                body.append(boundarySuffixData)
            } else {
                callback(500, nil, .customError("Failed to create multipart data"))
                return
            }
        } catch {
            callback(500, nil, .customError("Failed to read file data: \(error.localizedDescription)"))
            return
        }

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                callback(500, nil, .invalidResponse)
                return
            }

            guard let data = data else {
                callback(httpResponse.statusCode, nil, .customError("No data received"))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(HttpResponse<T>.self, from: data)
                callback(httpResponse.statusCode, decodedResponse.data, nil)
            } catch {
                callback(httpResponse.statusCode, nil, .customError("Failed to decode response: \(error.localizedDescription)"))
            }
        }
        task.resume()
    }
}

extension String {
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
}
