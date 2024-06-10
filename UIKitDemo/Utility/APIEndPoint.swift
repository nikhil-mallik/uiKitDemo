//
//  APIEndPoint.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 07/06/24.
//

import Foundation

// Enum defining various API endpoints
enum APIEndPoint {
    case login(loginData: LoginModel)
    case register(registerData: RegisterModel)
    case logout
    case products
    case users
}

extension APIEndPoint: EndPointType {
    // define headers for each endpoint
    var headers: [String : String]? {
        switch self {
        case .login, .register, .products, .users:
            return APIManager.commonHeaders
    
        case .logout:
            return APIManager.logoutHeaders
       
        }
    }
    
    // define baseURL for each endpoint
    var baseURL: String {
        switch self {
        case .login:
            return "https://api.backendless.com/\(app_id)/\(rest_key)/users/"
        case .register:
            return "https://api.backendless.com/\(app_id)/\(rest_key)/users/"
        case .logout:
            return "https://api.backendless.com/\(app_id)/\(rest_key)/users/"
        case .products:
            return "https://fakestoreapi.com/"
        case .users:
            return "https://jsonplaceholder.typicode.com/"
        
        }
    }
    
    // define path for each endpoint
    var path: String {
        switch self {
        case .login:
            return "login"
        case .register:
            return "register"
        case .products:
            return "products"
        case .users:
            return "todos/"
        case .logout:
            return "logout"
        }
    }
    
    // define url
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    // define methods for each endpoint
    var method: HTTPMethods {
        switch self {
        case .login, .register:
            return .post
        case .products, .logout, .users:
            return .get
        }
    }
    
    // define body for each endpoint
    var body: (any Encodable)? {
        switch self {
        case .login(let data):
            return data
        case .register(let data):
            return data
        case .products, .logout, .users:
            return nil
        }
    }
}
