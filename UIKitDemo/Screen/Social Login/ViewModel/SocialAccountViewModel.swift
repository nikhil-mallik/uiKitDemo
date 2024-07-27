//
//  SocialAccountViewModel.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 26/07/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth



class SocialAccountViewModel {
    
    weak var delegate: SocialAccountViewModelDelegate?

    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        _ = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)

        delegate?.didSignInSuccessfully()
    }
    
    
    func signInApple() async throws {
        let helper = await SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        _ = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        
        delegate?.didSignInSuccessfully()
    }
    

    func isLoggedIn() -> Bool {
        return AuthenticationManager.shared.isUserLoggedIn()
     }
     
     func signOut() throws {
         try AuthenticationManager.shared.signOut()
     }
    

    
}
