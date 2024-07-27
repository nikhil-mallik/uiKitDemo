//
//  SocialDashboardViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 26/07/24.
//

import UIKit

class SocialDashboardViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var modeOfLoginLbl: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    // MARK: - Variables
    private var viewModel = SocialAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataToUI()
    }
    
    func setDataToUI() {
        do {
            let user = try AuthenticationManager.shared.getAuthenticatedUser()
            nameLbl.text = "name: \(user.name ?? "")"
            emailLbl.text = "email: \(user.email ?? "")"
            
            let providers = try AuthenticationManager.shared.getProviders()
            let value = providers.map { $0.rawValue }.joined(separator: ", ")
            modeOfLoginLbl.text = "mode: \(value)"
        } catch {
            print("Failed to get user data: \(error)")
        }
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        do {
            try viewModel.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            // Handle error
            print("Logout failed: \(error)")
        }
    }
    
}
// MARK: - Extension
extension SocialDashboardViewController {
    
    // Create an instance of DashboardViewController from storyboard
    static func sharedIntance() -> SocialDashboardViewController {
        return SocialDashboardViewController.instantiateFromStoryboard("SocialDashboardViewController")
    }
}
