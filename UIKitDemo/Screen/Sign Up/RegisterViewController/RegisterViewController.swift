//
//  RegisterViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var fnameTextField: UITextField!
    @IBOutlet weak var lnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Variables
    private var viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.vc = self
                setUpElements()
                observeEvent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Clear textfield after the Screen disappear
        fnameTextField.text = ""
        lnameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        // Hide the activity indicator when the task is done
        Utility.setButtonLoadingState(button: signUpButton, isLoading: false)
    }
    
    // MARK: - Actions
    @IBAction func signUpButtonTtapped(_ sender: Any) {
        // Clearing previous error message
        hideError()
        
        // Validate fields
        if let errorMessage = validateRegisterFields() {
            // Display error message
            showError(errorMessage)
        } else {
            // Show the activity indicator when the button is tapped
            Utility.setButtonLoadingState(button: signUpButton, isLoading: true)
            // No validation errors, proceed with API call
            registerUser()
        }
    }
}

// MARK: - Extensions
extension RegisterViewController {
    
    // Set up UI elements
    func setUpElements() {
        Utility.setButtonLoadingState(button: signUpButton, isLoading: false)
        // Hide the error label
        hideError()
        
        // Style the text fields
        fnameTextField.styledTextField()
        lnameTextField.styledTextField()
        emailTextField.styledTextField()
       passwordTextField.styledTextField()
    }
    
    // Register user with provided details
    func registerUser() {
        let fname = fnameTextField.trimmedText()
        let lname = lnameTextField.trimmedText()
        let email = emailTextField.trimmedText()
        let password =  passwordTextField.trimmedText()
        let registerData = RegisterModel(name: "\(fname) \(lname)", email: email, password: password)
        
        // Call register user method from view model
        viewModel.registerUser(parameters: registerData)
    }
    
    // Observe events from view model
    func observeEvent() {
           viewModel.eventHandler = { [weak self] event in
               guard let self = self else { return }
               
               DispatchQueue.main.async {
                   switch event {
                   case .loading:
                       Utility.setButtonLoadingState(button: self.signUpButton, isLoading: true)
                   case .stopLoading:
                       Utility.setButtonLoadingState(button: self.signUpButton, isLoading: false)
                   case .dataLoaded:
                       print("Data Loaded")
                   case .dataPassed:
                       print("Data Passed")
                   case .error(let error):
                       self.showError(error?.localizedDescription ?? "An error occurred")
                   }
               }
           }
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
    
    // Validate register fields
    func validateRegisterFields() -> String? {
        return Validation.validateFields(
            firstName: fnameTextField.text,
            lastName: lnameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
    
    // Navigate to login view controller
    func navigateToLogin() {
            let loginVC = LoginViewController.sharedIntance()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
}
