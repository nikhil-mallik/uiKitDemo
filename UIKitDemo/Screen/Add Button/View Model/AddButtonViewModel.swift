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
        totalButton = (1...count).map { AddButtonModel(count: $0) }
    }
}
