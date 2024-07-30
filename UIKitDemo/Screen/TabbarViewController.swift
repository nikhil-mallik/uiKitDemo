//
//  TabbarViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 30/07/24.
//

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.delegate = self
        self.title = "Home"
        navigationItem.hidesBackButton = true
        setupLogoutButton()
    }
    
    // Setup logout button
    func setupLogoutButton() {
        let logoutImage = UIImage(systemName: "xmark")
        let logoutButton = UIBarButtonItem(image: logoutImage, style: .plain, target: self, action: #selector(logoutTapped))
        logoutButton.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func logoutTapped() {
        // Perform logout API call
        APIManager.shared.logoutApiCall(vc: self)
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let title = viewController.tabBarItem.title {
            navigationItem.title = title
        }
    }
}

// MARK: - Extension
extension TabbarViewController {
    // Create an instance of ViewController from storyboard
    static func sharedIntance() -> TabbarViewController {
        return TabbarViewController.instantiateFromStoryboard("TabbarViewController")
    }
}
