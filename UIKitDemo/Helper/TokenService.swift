//
//  TokenService.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 07/06/24.
//

import UIKit

// MARK: - TokenService Class
class TokenService {
    // Singleton instance of TokenService
    static let tokenShared = TokenService()
    let userDefault = UserDefaults.standard
    
    // Method to save the token and username to UserDefaults
    func saveToken(token: String, name: String) {
        userDefault.set(token, forKey: TokenKey.userLogin)
        userDefault.set(name, forKey: TokenKey.userName)
    }
    
    // Method to retrieve the token from UserDefaults
    func getToken() -> String {
        // Check if the token exists in UserDefaults and return it, otherwise return an empty string
        if let token = userDefault.object(forKey: TokenKey.userLogin) as? String {
            return token
        }
        return ""
    }
    
    // Method to retrieve the username from UserDefaults
    func getName() -> String {
        // Force unwrap is safe here as we know the value should exist if saved correctly
        return userDefault.string(forKey: TokenKey.userName) ?? "Test"
    }
    
    // Method to check if a user is logged in based on the presence of a token
    func checkForLogin() -> Bool {
        // If the token is an empty string, return false (not logged in), otherwise return true (logged in)
        return getToken() != ""
    }
    
    // Method to remove the token from UserDefaults
    func removeToken() {
        userDefault.removeObject(forKey: TokenKey.userLogin)
    }
}

