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
    static func showConfirmationAlert(title: String, message: String, in viewController: UIViewController, confirmAction: @escaping () -> Void, cancelAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
            confirmAction()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelAction?()
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    // MARK: - Alert for Enums
    func showEnumAlert<T: RawRepresentable & CaseIterable>(
        title: String,
        message: String,
        enumType: T.Type,
        handler: @escaping (T) -> Void
    ) where T.RawValue == String {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add actions for each enum case
        enumType.allCases.forEach { value in
            alert.addAction(UIAlertAction(title: value.rawValue, style: .default, handler: { _ in
                handler(value)
            }))
        }
        
        // Add a cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
 
 
    
}

