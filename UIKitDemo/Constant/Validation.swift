//
//  Validation.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 07/06/24.
//

import Foundation

// MARK: - Validation Class
class Validation {
    
    // Checks if the provided text field is empty after trimming whitespace and newlines
    static func isFieldEmpty(_ text: String?) -> Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
    
    // Validates if the provided password meets the required criteria:
    // At least 8 characters, contains at least one uppercase letter, one lowercase letter, one number, and one special character
    static func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    // Validates if the provided email follows the standard email format
    static func isEmailValid(_ email: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailTest.evaluate(with: email)
    }
    
    // Validates multiple fields: first name, last name, email, and password
    static func validateFields(firstName: String? = nil, lastName: String? = nil, email: String?, password: String?) -> String? {
        // Check that all required fields are filled in
        if let firstName = firstName, isFieldEmpty(firstName) {
            return "First name is required."
        }
        if let lastName = lastName, isFieldEmpty(lastName) {
            return "Last name is required."
        }
        if isFieldEmpty(email) {
            return "Email is required."
        }
        if isFieldEmpty(password) {
            return "Password is required."
        }
        
        // Check if the email is valid
        let cleanedEmail = email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !isEmailValid(cleanedEmail) {
            return "Please enter a valid email address."
        }
        
        // Check if the password is secure
        let cleanedPassword = password?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !isPasswordValid(cleanedPassword) {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        // All validations passed
        return nil
    }
}
