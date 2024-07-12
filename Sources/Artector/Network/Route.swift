//
//  Route.swift
//
//
//  Created by danny santoso on 7/12/24.
//

struct Route {
    static let baseUrl = "https://8b31-114-124-142-204.ngrok-free.app/"
}

protocol Endpoint {
    var url: String { get }
}

enum Endpoints {
    enum Posts: Endpoint {
        case upload
        
        public var url: String {
            switch self {
            case .upload: return "\(Route.baseUrl)/upload"
            }
        }
    }
    
    enum Gets: Endpoint {
        case images
        
        public var url: String {
            switch self {
            case .images: return "\(Route.baseUrl)/images"
            }
        }
    }
}

