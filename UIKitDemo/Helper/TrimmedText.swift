//
//  trimmedText.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 07/06/24.
//

import UIKit

// MARK: - TrimmedTextHelper Class
class TrimmedTextHelper {
    // Method to get trimmed text from a UITextField
    static func trimmedText(from textField: UITextField) -> String {
        // Trim whitespace and newlines from the text, or return an empty string if the text is nil
        return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
