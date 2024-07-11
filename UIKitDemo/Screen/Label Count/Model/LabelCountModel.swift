//
//  LabelCountModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 10/07/24.
//

import Foundation

class LabelCountModel: NSObject {
    @objc dynamic var labelCount: Int
    
    init(labelCount: Int) {
        self.labelCount = labelCount
    }
}
