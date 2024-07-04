//
//  ProfileListViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 04/07/24.
//

import UIKit

class ProfileListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarBtn: UIBarButtonItem!
    
    // MARK: - Variables
    private var viewModel = ProfileAddViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    func clearUserData() {
        viewModel.userData.removeAll()
    }
    
    // Method for initial configuration
    func configuration() {
        viewModel.viewController = self
        tableView.dataSource = self
        tableView.delegate = self
        // Register custom cell nib for table view
        tableView.register(UINib(nibName: "ProfileListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileListTableViewCell")
    }
    
    @IBAction func navBarBtnAction(_ sender: Any) {
        let profileAddVC = AddProfileViewController.sharedIntance()
        self.navigationController?.pushViewController(profileAddVC, animated: true)
    }
}

// MARK: - Extension for shared instance
extension ProfileListViewController {
    static func sharedIntance() -> ProfileListViewController {
        return ProfileListViewController.instantiateFromStoryboard("ProfileListViewController")
    }
}

// Extension conforming to UITableViewDataSource protocol
extension ProfileListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileListTableViewCell") as? ProfileListTableViewCell else {
            return UITableViewCell()
        }
        let user = viewModel.userData[indexPath.row]
        cell.userDetail = user
        return cell
    }
}

// Extension conforming to UITableViewDelegate protocol
extension ProfileListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.userData.count else { return }
        let selectedUser = viewModel.userData[indexPath.row]
        // Instantiate FetchProfileTableViewController
        if let fetchProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "FetchProfileTableViewController") as? FetchProfileTableViewController {
            fetchProfileVC.profileData = selectedUser
            fetchProfileVC.currentIndex = indexPath.row
            fetchProfileVC.viewModel.userData = viewModel.userData
            self.navigationController?.pushViewController(fetchProfileVC, animated: true)
        } else {
            print("Failed to instantiate FetchProfileTableViewController from storyboard.")
        }
    }
}
