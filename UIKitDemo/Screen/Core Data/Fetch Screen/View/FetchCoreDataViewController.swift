//
//  FetchCoreDataViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 16/07/24.
//

import UIKit

class FetchCoreDataViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var navAddBtn: UIBarButtonItem!
    @IBOutlet weak var listTableView: UITableView!
    
    // MARK: - Variable
    private var users: [UserEntity] = []
    private let manager = DatabaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.register(UINib(nibName: "UserCoreDataTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCoreDataTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        users = manager.fetchUsers()
        listTableView.reloadData()
    }
    
    // MARK: - Action Methods
    @IBAction func navAddBtnAction(_ sender: UIButton) {
        addUpdateUserNavigation()
    }
    
    // MARK: - Navigation Methods
    func addUpdateUserNavigation(user: UserEntity? = nil) {
        let addCoreDataVC = AddEditCoreDataViewController.sharedInstance()
        addCoreDataVC.user = user
        self.navigationController?.pushViewController(addCoreDataVC, animated: true)
    }
}

// MARK: - Extension for shared instance
extension FetchCoreDataViewController {
    static func sharedInstance() -> FetchCoreDataViewController {
        return FetchCoreDataViewController.instantiateFromStoryboard("FetchCoreDataViewController")
    }
}

// MARK: - UITableViewDataSource
extension FetchCoreDataViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCoreDataTableViewCell") as? UserCoreDataTableViewCell else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension FetchCoreDataViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(style: .normal, title: "Update") { _, _, _ in
            self.addUpdateUserNavigation(user: self.users[indexPath.row])
        }
        update.backgroundColor = .systemIndigo
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.manager.deleteUser(userEntity: self.users[indexPath.row]) // Core Data
            self.users.remove(at: indexPath.row) // Array
            self.listTableView.reloadData()
        }
    
        return UISwipeActionsConfiguration(actions: [delete, update])
    }
}
