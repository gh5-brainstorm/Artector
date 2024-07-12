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

public struct SimilarityResponse: Decodable {
    let imageName: String
    let similarImage: [ImageResponse]
    
    private enum CodingKeys: String, CodingKey {
        case imageName = "image_name"
        case similarImage = "similar_image"
    }
}

public struct ImageResponse: Decodable {
    let url: String
    let similarityScore: Float
    
    private enum CodingKeys: String, CodingKey {
        case url
        case similarityScore = "similarity_score"
    }
}
