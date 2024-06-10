//
//  EndPointType.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 07/06/24.
//

import Foundation

// Enum representing possible errors related to data handling
enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}

// Enum representing HTTP methods
enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

// Protocol defining the structure of an API endpoint
protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}

// Enum representing various events during data processing
enum Event {
    case loading
    case stopLoading
    case dataLoaded
    case dataPassed
    case error(Error?)
}
