//
//  RegisterModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//

import Foundation

struct RegisterModel: Codable {
    let name : String
    let email : String
    let password : String
}


// MARK: - RegisterResponseModel
struct RegisterResponseModel: Codable {
    let userStatus: String
    let created: Int
    let ownerID: String
    let name, registerResponseModelClass, blUserLocale: String
    let objectID, email: String

    enum CodingKeys: String, CodingKey {
        case userStatus, created
        case ownerID = "ownerId"
        case name
        case registerResponseModelClass = "___class"
        case blUserLocale
        case objectID = "objectId"
        case email
    }
}
