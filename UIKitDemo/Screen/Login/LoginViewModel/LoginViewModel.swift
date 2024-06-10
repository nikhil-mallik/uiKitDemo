//
//  LoginViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 10/06/24.
//

import Foundation

class LoginViewModel {
    
    // Weak reference to LoginViewController
    weak var vc: LoginViewController?
    // Closure to handle events from the view model
    var eventHandler: ((_ event: Event) -> Void)?
    
    // Method to authenticate login credentials
    func loginAuth(parameters: LoginModel) {
        // Notify event handler
        eventHandler?(.loading)
        // Make API request to authenticate login credentials
        APIManager.shared.request(
            requestModel: parameters,
            responseModelType: LoginResponseModel.self,
            type: APIEndPoint.login(loginData: parameters)
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let json):
                    print(json)
                    let userName = json.name
                    let userToken = json.userToken
                    // Save user token and name using TokenService
                    TokenService.tokenShared.saveToken(token: userToken, name: userName)
                    self.eventHandler?(.dataPassed)
                    // Navigate to dashboard view controller
                    self.vc?.navigateToDashboard()
                case .failure(let error):
                    print("Login failed with error: \(error)")
                    self.eventHandler?(.error(error))
                }
                
                // Notify event handler
                self.eventHandler?(.stopLoading)
            }
        }
    }
}
