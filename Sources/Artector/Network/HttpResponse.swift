//
//  HttpResponse.swift
//  
//
//  Created by danny santoso on 7/12/24.
//

import UIKit

struct HttpResponse<T: Decodable>: Decodable {
    
    /// The HTTP status code of the response.
    let statusCode: Int?
    
    /// A message associated with the response.
    let message: String?
    
    /// The decoded data of type `T`.
    let data: T?
    
    /// Private enum specifying the coding keys for decoding.
    private enum CodingKeys: String, CodingKey {
        case statusCode, message, data
    }
}

struct SuccessResponse: Decodable {
    let isSuccess: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
    }
}

struct ImageResponse: Decodable {
    let id: Int
    let url: String
}
