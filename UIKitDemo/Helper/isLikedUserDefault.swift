//
//  isLikedUserDefault.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 14/06/24.
//

import Foundation

struct isLikedUserDefault {
    
    // Singleton instance
    static let shared = isLikedUserDefault()
    private let userDefault = UserDefaults.standard
    
    // Method to save the like status for a product
    func saveLikeStatus(productId: Int, isLiked: Bool) {
        let likeStatusKey = isLikedValue.isLikedProduct + String(productId)
        userDefault.set(isLiked, forKey: likeStatusKey)
    }
    
    // Method to retrieve the like status for a product
    func getLikeStatus(for productId: Int) -> Bool {
        let likeStatusKey = isLikedValue.isLikedProduct + String(productId)
        return userDefault.bool(forKey: likeStatusKey)
    }
    
    // Method to clear the like status for a product 
    func clearLikeStatus(for productId: Int) {
        let likeStatusKey = isLikedValue.isLikedProduct + String(productId)
        userDefault.removeObject(forKey: likeStatusKey)
    }
}
