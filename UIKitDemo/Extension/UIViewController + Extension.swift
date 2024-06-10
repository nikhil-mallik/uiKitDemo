//
//  UIViewController + Extension.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//

import UIKit

// MARK: - UIViewController Extension
extension UIViewController {
    // Method to instantiate a view controller from a storyboard by name
    class func instantiateFromStoryboard(_ name: String) -> Self {
        return instantiateFromStoryboardHelper(name) // Call the helper method
    }
    
    // Helper method to handle the instantiation from the storyboard
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        // Load the storyboard named "Main"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Instantiate the view controller with the provided identifier
        let controller = storyboard.instantiateViewController(withIdentifier: "\(name.self)") as! T
        return controller // Return the instantiated view controller
    }
}
