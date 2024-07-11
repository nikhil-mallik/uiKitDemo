//
//  LoginViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButtonTapped: UIButton!
    
    // MARK: - Variables
    private var viewModel = LoginViewModel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.vc = self
        initViewData()
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("Button Tapped")
        // Clearing previous error message
        hideError()
        
        // Validate fields
        if let errorMessage = validateLoginFields() {
            Utility.setButtonLoadingState(button: loginButton, isLoading: false)
            // Display error message
            showError(errorMessage)
        } else {
            // No validation errors, proceed with API call
            loginCheckCredential()
        }
    }
    
}

// MARK: - Extensions
extension LoginViewController {
    
    // Static method to get shared instance of LoginViewController
    static func sharedIntance() -> LoginViewController {
        return LoginViewController.instantiateFromStoryboard("LoginViewController")
    }
    
    func initViewData() {
        hideError()
        // Apply styles to text fields
        emailTextField.styledTextField()
        passwordTextField.styledTextField()
        Utility.setButtonLoadingState(button: loginButton, isLoading: false)
        observeEvent()
    }
    
    // Validate Login fields
    func validateLoginFields() -> String? {
        return Validation.validateFields(
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
    
    // Perform login check with credentials
    func loginCheckCredential() {
        Utility.setButtonLoadingState(button: loginButton, isLoading: true)
        let email = emailTextField.trimmedText()
        let password = passwordTextField.trimmedText()
        
        let loginData = LoginModel(login: email, password: password)
        print(loginData)
        
        // Call login authentication method from view model
        viewModel.loginAuth(parameters: loginData)
    }
    
    // Observe events from view model
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch event {
                case .loading:
                    Utility.setButtonLoadingState(button: self.loginButton, isLoading: true)
                case .stopLoading:
                    Utility.setButtonLoadingState(button: self.loginButton, isLoading: false)
                case .dataLoaded:
                    print("Data Loaded")
                case .dataPassed:
                    print("Data Passed")
                case .error(let error):
                    self.showError(String(describing: error?.localizedDescription))
                }
            }
        }
    }
    
    // Navigate to dashboard view controller
    func navigateToDashboard() {
        let dashboardVC = DashboardViewController.sharedIntance()
        self.navigationController?.pushViewController(dashboardVC, animated: true)
    }
    
    // Show error message
    func showError(_ message: String) {
        print(message)
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    // Hide error message
    func hideError() {
        errorLabel.alpha = 0
        errorLabel.text = ""
    }
}
