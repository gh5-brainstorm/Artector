//
//  Route.swift
//
//
//  Created by danny santoso on 7/12/24.
//

struct Route {
    static let baseUrl = "https://7f0e-111-67-81-27.ngrok-free.app"
}

protocol Endpoint {
    var url: String { get }
}

enum Endpoints {
    enum Posts: Endpoint {
        case upload
        
        /// The URL for the single sign-on endpoint.
        public var url: String {
            switch self {
            case .upload: return "\(Route.baseUrl)/upload"
            }
        }
    }
}

