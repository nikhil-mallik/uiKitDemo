//
//  productListModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 08/06/24.
//

import Foundation

struct ProductListModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    var isLiked: Bool?
    let rating: Rate
}

struct Rate: Codable {
    let rate: Double
    let count: Int
}
