//
//  RegisterViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 07/06/24.
//

import Foundation

class RegisterViewModel {
    // Reference to RegisterViewController
    weak var vc: RegisterViewController?
    // Closure for data binding
    var eventHandler: ((_ event: Event) -> Void)?
    
    // Register user with provided parameters
    func registerUser(parameters: RegisterModel) {
        // Notify loading state
        eventHandler?(.loading)
        
        // Make API request for registration
        APIManager.shared.request(
            requestModel: parameters,
            responseModelType: RegisterResponseModel.self,
            type: APIEndPoint.register(registerData: parameters)
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.eventHandler?(.dataPassed)
                    // Navigate to login screen
                    self.vc?.navigateToLogin()
                case .failure(let error):
                    print("Registration failed with error: \(error)")
                    self.eventHandler?(.error(error))
                }
                // Notify loading stopped
                self.eventHandler?(.stopLoading)
            }
        }
    }
}
