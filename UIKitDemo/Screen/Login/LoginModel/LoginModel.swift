//
//  LoginModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//

import Foundation

struct LoginModel: Codable {
    let login : String
    let password : String
   
}

struct LoginResponseModel: Codable {
    let lastLogin: Int?
    let userStatus: String
    let created: Int
    let accountType: String
    let socialAccount: String?
    let ownerID: String
    let name: String
    let loginResponseModelClass: String
    let blUserLocale: String
    let userToken: String
    let updated: Int?
    let objectID: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case lastLogin, userStatus, created, accountType, socialAccount
        case ownerID = "ownerId"
        case name
        case loginResponseModelClass = "___class"
        case blUserLocale
        case userToken = "user-token"
        case updated
        case objectID = "objectId"
        case email
    }
}

