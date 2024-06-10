//
//  AlertHelper.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 07/06/24.
//

import UIKit

// MARK: - AlertHelper Class
class AlertHelper {
    // Method to show an alert with a title, message, and optional completion handler
    static func showAlert(
        withTitle title: String,
        message: String,
        from viewController: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        // Create the alert controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add an "OK" action to the alert
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?() // Call the completion handler if provided
        })
        
        // Present the alert from the specified view controller
        viewController.present(alert, animated: true, completion: nil)
    }
}
