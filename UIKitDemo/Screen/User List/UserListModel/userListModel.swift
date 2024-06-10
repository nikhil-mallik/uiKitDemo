//
//  userListModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 08/06/24.
//

import UIKit

import UIKit

// MARK: - UserListModel Struct
struct UserListModel: Codable {
    let uid: Int? // User ID
    let id: Int? // ID
    let title: String? // Title
    let completed: Bool? // Completion status

    // Coding keys to map the JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case uid = "userId"
        case id = "id"
        case title = "title"
        case completed = "completed"
    }
    
    // Method to get the status color based on the completion status
    func getStatusColor() -> (String, UIColor) {
        if completed ?? true {
            return ("COMPLETED", UIColor.systemGray) // Return "COMPLETED" with system gray color
        } else {
            return ("NOT COMPLETED", UIColor.red) // Return "NOT COMPLETED" with red color
        }
    }
}

