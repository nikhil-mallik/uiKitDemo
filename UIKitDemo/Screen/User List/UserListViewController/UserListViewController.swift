//
//  UserListViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 08/06/24.
//

import UIKit

// MARK: - UserListViewController Class
class UserListViewController: UIViewController {
    
    // Outlet for the table view displaying user list
    @IBOutlet weak var userListTableView: UITableView!
    
    // View model for user list
    var viewModelUser = UserListViewModel()
    
    // Method called when the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
}

// MARK: - UITableViewDataSource Extension
extension UserListViewController: UITableViewDataSource {
    // Method to specify the number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelUser.arrUsers.count
    }
    
    // Method to configure and return a table view cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as? UserListCell
        cell?.modelUser = viewModelUser.arrUsers[indexPath.row]
        return cell!
    }
}

// MARK: - UserListViewController Extension
extension UserListViewController {
    
    // Method for initial configuration
    func configuration() {
        // Register cell nib
        userListTableView.register(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "UserListCell")
        initViewModel()
        observeEvent()
    }
    
    // Method to initialize the view model
    func initViewModel() {
        viewModelUser.getAllUserData() 
    }
    
    // Method to observe events from the view model
    func observeEvent() {
        viewModelUser.eventHandler = { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .loading:
                print("Product loading....")
            case .stopLoading:
                print("Stop loading...")
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    // Reload table view data on main thread
                    self.userListTableView.reloadData()
                }
            case .error(let error):
                print(error as Any)
            case .dataPassed:
                print("Data passed...")
            }
        }
    }
    
    // Static method to get shared instance of UserListViewController
    static func sharedIntance() -> UserListViewController {
        return UserListViewController.instantiateFromStoryboard("UserListViewController")
    }
}

