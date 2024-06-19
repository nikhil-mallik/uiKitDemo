//
//  AddButtonViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 14/06/24.
//

import Foundation

class AddButtonViewModel {
    // Array to hold count
    var totalButton: [AddButtonModel] = []
    
    // Method to update count
    func updateButtonCount(to count: Int) {
        
//        clearTotalButtonCount()
        
        // Add new array elements
        totalButton = (1...count).map { AddButtonModel(count: $0) }
    }
    
//    func clearTotalButtonCount() {
//        // Clear previous array
//        totalButton.removeAll()
//        print("total count -> \(totalButton.count)")
//    }
}
