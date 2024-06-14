//
//  AddButtonModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 13/06/24.
//

import Foundation

struct AddButtonModel: Codable {
    let count: Int
    
    init(count: Int) {
        self.count = count
    }
}
