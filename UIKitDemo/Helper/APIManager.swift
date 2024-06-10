//
//  APIManager.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//


import Alamofire
import UIKit

// Type alias for the result handler with a generic type
typealias ResultHandler<T> = (Result<T, DataError>) -> Void

// MARK: - APIManager Class
final class APIManager {

    // Singleton instance of APIManager
    static let shared = APIManager()
    private let networkHandler: NetworkHandler

    // Initializer with dependency injection for NetworkHandler
    init(networkHandler: NetworkHandler = NetworkHandler()) {
        self.networkHandler = networkHandler
    }

    // Method to make a network request
    func request<Response: Decodable>(
        requestModel: Encodable?,
        responseModelType: Response.Type,
        type: EndPointType,
        completion: @escaping ResultHandler<Response>
    ) {
        // Ensure the URL is valid
        guard let url = type.url else {
            completion(.failure(.invalidURL))
            return
        }

        // Create and configure the URL request
        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue
        request.allHTTPHeaderFields = type.headers

        // Encode the request model if available
        if let requestModel = requestModel {
            do {
                request.httpBody = try JSONEncoder().encode(requestModel)
            } catch {
                completion(.failure(.decoding(error)))
                return
            }
        }

        // Make the network request using NetworkHandler
        networkHandler.requestDataAPI(url: request) { result in
            switch result {
            case .success(let data):
                do {
                    let responseModel = try JSONDecoder().decode(responseModelType, from: data)
                    completion(.success(responseModel))
                } catch {
                    completion(.failure(.decoding(error)))
                }
            case .failure(let error):
                completion(.failure(.network(error)))
            }
        }
    }
    
    // Method to handle logout API call
    func logoutApiCall(vc: UIViewController) {
        
        // Ensure the logout URL and headers are valid
        guard let logout_url = APIEndPoint.logout.url else { return }
        guard let logoutHeaders = APIEndPoint.logout.headers else { return }
  
        // Make the logout API request using Alamofire
        AF.request(logout_url, method: .get, headers: HTTPHeaders(logoutHeaders)).response {
            response in
            switch response.result {
            case .success(_):
                // Remove the token and navigate to the root view controller
                TokenService.tokenShared.removeToken()
                let rootVC = ViewController.sharedIntance()
                vc.navigationController?.pushViewController(rootVC, animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Common headers for API requests
    static var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    } 
    
    // Headers for logout API requests
    static var logoutHeaders: [String: String] {
        return [
            "user-token" : "\(String(describing: TokenService.tokenShared.getToken))"
        ]
    }
}

class NetworkHandler {

    func requestDataAPI(url: URLRequest, completion: @escaping (Result<Data, DataError>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.network(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
