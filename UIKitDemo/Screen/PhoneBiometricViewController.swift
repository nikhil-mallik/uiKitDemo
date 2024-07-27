//
//  PhoneBiometricViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 27/07/24.
//

import UIKit
import LocalAuthentication
//import LocalAuthenticationEmbeddedUI

class PhoneBiometricViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func biometricBtnAction(_ sender: Any) {
        BiometricHelper.shared.authenticateUser { [weak self] in
            guard let self = self else { return }
            let vc = UIViewController()
            vc.title = "Welcome"
            vc.view.backgroundColor = .systemIndigo
            self.present(UINavigationController(rootViewController: vc), animated: true,completion: nil)
        }
    }
}

// MARK: - Extension for shared instance
extension PhoneBiometricViewController {
    static func sharedInstance() -> PhoneBiometricViewController {
        return PhoneBiometricViewController.instantiateFromStoryboard("PhoneBiometricViewController")
    }
}
