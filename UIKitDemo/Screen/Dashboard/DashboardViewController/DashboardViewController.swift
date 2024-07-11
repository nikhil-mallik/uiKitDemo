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
    @IBOutlet weak var logoutButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var collectionViewButton: UIButton!
    @IBOutlet weak var buttonCollectionViewBtn: UIButton!
    @IBOutlet weak var buttonScrollViewBtn: UIButton!
    @IBOutlet weak var countryDropdownBtn: UIButton!
    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var profileSectionBtn: UIButton!
    @IBOutlet weak var stickyHeader: UIButton!
    // Holds the user's name
    var userName = ""
    
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
        userListVC.navigationItem.title = "User List"
        self.navigationController?.pushViewController(userListVC, animated: true)
    }
    
    @IBAction func productListButtonTapped(_ sender: Any) {
        // Navigate to the product list screen
        let productListVC = ProductListViewController.sharedIntance()
        productListVC.navigationItem.title = "Product List"
        self.navigationController?.pushViewController(productListVC, animated: true)
    }
    
    @IBAction func collectionViewAction(_ sender: Any) {
        // Navigate to the product Collection View screen
        let productListVC = CollectionViewController.sharedIntance()
        productListVC.navigationItem.title = "Collection View"
        self.navigationController?.pushViewController(productListVC, animated: true)
    }
    
    @IBAction func buttonCollectionViewBtnAction(_ sender: Any) {
        // Navigate to the Generate Button Collection View screen
        let addButtonVC = AddButtonViewController.sharedIntance()
        addButtonVC.navigationItem.title = "Collection View Btn"
        self.navigationController?.pushViewController(addButtonVC, animated: true)
    }
    
    @IBAction func buttonScrollViewBtnAction(_ sender: Any) {
        // Navigate to the Generate Button Scroll View screen
        let addButtonVC = ButtonScrollView.sharedIntance()
        addButtonVC.navigationItem.title = "Custom Button"
        self.navigationController?.pushViewController(addButtonVC, animated: true)
    }
    
    @IBAction func countryDropdownBtnAction(_ sender: Any) {
        // Navigate to the Country Dropdown View screen
        let countryVC = CountryViewController.sharedIntance()
        countryVC.navigationItem.title = "Country API"
        self.navigationController?.pushViewController(countryVC, animated: true)
    }
    
    @IBAction func userImageAction(_ sender: Any) {
        let userImageVC = UserImageScrollViewController.sharedIntance()
        self.navigationController?.pushViewController(userImageVC, animated: true)
    }
    
    @IBAction func profileSectionAction(_ sender: Any) {
        let profileVC = ProfileListViewController.sharedIntance()
        profileVC.clearUserData()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction func stickyHeaderAction(_ sender: UIButton) {
        let stickyVC = StickHeaderViewController.sharedIntance()
        stickyVC.navigationItem.title = "Sticky Header"
        self.navigationController?.pushViewController(stickyVC, animated: true)
    }
    
    
    @IBAction func taskManager(_ sender: Any) {
        let taskVC = TaskManagerViewController.sharedIntance()
        taskVC.viewModel.clearArray()
        self.navigationController?.pushViewController(taskVC, animated: true)
    }
    
    
    @IBAction func labelCountAction(_ sender: Any) {
        let labelCountVC = LabelCountAViewController.sharedIntance()
        labelCountVC.title = "Label A"
        labelCountVC.viewModel.resetCount()
        self.navigationController?.pushViewController(labelCountVC, animated: true)
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
