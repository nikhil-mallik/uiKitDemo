//
//  BiometricAuth.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 27/07/24.
//

import LocalAuthentication
import UIKit

class BiometricHelper {
    
    // Singleton instance of BiometricHelper
    static let shared = BiometricHelper()
    
    private init() {}
    
    // Authenticates the user using biometrics
    func authenticateUser(successHandler: @escaping () -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available on the device
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Show alert if biometrics are unavailable
            DispatchQueue.main.async {
                self.showBiometricsUnavailableAlert()
            }
            return
        }
        
        let reason = "Authenticate to access the app"
        
        // Perform biometric authentication
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
            DispatchQueue.main.async {
                // Call the success handler on successful authentication
                if success {
                    successHandler()
                } else {
                    // Show alert on authentication failure
                    self.showAuthenticationFailedAlert(successHandler: successHandler)
                }
            }
        }
    }
    
    //Shows an alert when authentication fails
    private func showAuthenticationFailedAlert(successHandler: @escaping () -> Void) {
        showAlert(title: "Authentication Failed", message: "Please try again.", actions: [
            UIAlertAction(title: "Try Again", style: .default) { _ in
                // Retry biometric authentication
                self.authenticateUser(successHandler: successHandler)
            },
            UIAlertAction(title: "Cancel", style: .destructive) { _ in
                // Exit the app
                exit(0)
            }
        ])
    }
    
    // Shows an alert when biometrics are unavailable
    private func showBiometricsUnavailableAlert() {
        showAlert(title: "Biometrics Unavailable", message: "Your device does not support biometric authentication.", actions: [
            UIAlertAction(title: "OK", style: .default) { _ in
                // Exit the app
                exit(0)
            }
        ])
    }
    
    /// Shows an alert with given title, message, and actions
    private func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        guard let topController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        topController.present(alert, animated: true, completion: nil)
    }
}
