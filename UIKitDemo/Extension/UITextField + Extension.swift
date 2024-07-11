//
//  UIButton + Extension.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 14/06/24.
//

import UIKit

class CustomUITextField: UITextField {
   override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
   }
}

// MARK: - UITextField Extension
extension UITextField {
    // Method to get trimmed text from a UITextField
    func trimmedText() -> String {
        // Trim whitespace and newlines from the text, or return an empty string if the text is nil
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
        
    func styledTextField() {
        // Create the bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 75/255, green: 0/255, blue: 130/255, alpha: 1).cgColor
        // Add the line to the text field
        self.layer.addSublayer(bottomLine)
    }
}
