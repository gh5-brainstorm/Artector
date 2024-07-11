//
//  URLError.swift
//
//
//  Created by danny santoso on 7/12/24.
//

import Foundation

enum URLError: LocalizedError {
    
    case invalidResponse
    case addressUnreachable(URL)
    case customError(String?)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "The server responded with garbage."
        case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
        case .customError(let message): return message ?? "Unknown error occurred."
        }
    }
}
