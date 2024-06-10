//
//  DashboardViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//

import UIKit

class DashboardViewController : UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userListButton: UIButton!
    @IBOutlet weak var productListButton: UIButton!
    
    // Holds the user's name
    var userName = ""
    
    @IBOutlet weak var logoutButtonOutlet: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        getUserName() // Retrieve and display the user's name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set up the background video
        BgVideoPlay.shared.setUpVideo(on: self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop the video when the view disappears
        BgVideoPlay.shared.stopVideo()
    }
    
    // MARK: - Button Actions
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        // Perform logout API call
        APIManager.shared.logoutApiCall(vc: self)
    }
    
    @IBAction func userListButtonTapped(_ sender: Any) {
        // Navigate to the user list screen
        let userListVC = UserListViewController.sharedIntance()
        self.navigationController?.pushViewController(userListVC, animated: true)
    }
    
    @IBAction func productListButtonTapped(_ sender: Any) {
        // Navigate to the product list screen
        let productListVC = ProductListViewController.sharedIntance()
        self.navigationController?.pushViewController(productListVC, animated: true)
    }
}

// MARK: - Extension
extension DashboardViewController {
    
    // Create an instance of DashboardViewController from storyboard
    static func sharedIntance() -> DashboardViewController {
        return DashboardViewController.instantiateFromStoryboard("DashboardViewController")
    }
    
    // Retrieve and display the user's name
    func getUserName() {
        let userName = TokenService.tokenShared.getName()
        nameLabel.text = "Welcome \(userName)"
    }
}
