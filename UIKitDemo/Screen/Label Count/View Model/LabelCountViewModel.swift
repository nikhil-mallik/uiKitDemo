//
//  LabelCountViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 10/07/24.
//

import Foundation

class LabelCountViewModel: NSObject {
    // MARK: - Singleton Instance
    static let shared = LabelCountViewModel()
    private override init() {
        super.init()
        // Initialize counts with a default value
        counts = LabelCountModel(labelCount: 0)
    }
    
    @objc dynamic var counts: LabelCountModel?
    func addCount() {
        counts?.willChangeValue(forKey: "labelCount")
        counts?.labelCount += 1
        counts?.didChangeValue(forKey: "labelCount")
    }
    
    func subtractCount() {
        counts?.willChangeValue(forKey: "labelCount")
        counts?.labelCount -= 1
        counts?.didChangeValue(forKey: "labelCount")
    }
    
    func resetCount() {
        counts = LabelCountModel(labelCount: 0)
    }
}
