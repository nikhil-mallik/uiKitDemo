//
//  SocialAccountViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 26/07/24.
//

import UIKit
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

class SocialAccountViewController: UIViewController {
    
    @IBOutlet weak var googleBtn: GIDSignInButton!
    @IBOutlet weak var appleBtn: ASAuthorizationAppleIDButton!
    
    // MARK: - Variables
    private var viewModel = SocialAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleBtn.style = .wide
        
        setupAppleSignInButton()
        viewModel.delegate = self
        
        if viewModel.isLoggedIn() {
            navigateToSocialDashboard()
        }
    }
    
    
    @IBAction func googleBtnAction(_ sender: Any) {
        Task { @MainActor in
            print("Google Login")
            do {
                try await viewModel.signInGoogle()
            } catch {
                print(error)
            }
        }
    }
    
    func setupAppleSignInButton() {
        appleBtn.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
    }
    
    @objc func handleAppleSignIn() {
        Task { @MainActor in
            print("apple login")
            do {
                try await viewModel.signInApple()
            } catch {
                print(error)
            }
        }
    }
    
    
}

// MARK: - Extension
extension SocialAccountViewController {
    // Create an instance of ViewController from storyboard
    static func sharedIntance() -> SocialAccountViewController {
        return SocialAccountViewController.instantiateFromStoryboard("SocialAccountViewController")
    }
}

extension SocialAccountViewController: SocialAccountViewModelDelegate{
    
    func navigateToSocialDashboard() {
        let dashboardVC = SocialDashboardViewController.sharedIntance()
        self.navigationController?.pushViewController(dashboardVC, animated: true)
    }
    
    func didSignInSuccessfully() {
        DispatchQueue.main.async {
            self.navigateToSocialDashboard()
        }
    }
}

protocol SocialAccountViewModelDelegate: AnyObject {
    func didSignInSuccessfully()
}
