//
//  DashboardViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//

import UIKit

class DashboardViewController : UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var userListButton: UIButton!
    @IBOutlet weak var productListButton: UIButton!
    @IBOutlet weak var collectionViewButton: UIButton!
    @IBOutlet weak var buttonCollectionViewBtn: UIButton!
    @IBOutlet weak var buttonScrollViewBtn: UIButton!
    @IBOutlet weak var countryDropdownBtn: UIButton!
    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var profileSectionBtn: UIButton!
    @IBOutlet weak var stickyHeader: UIButton!
    @IBOutlet weak var taskManagerBtn: UIButton!
    @IBOutlet weak var labelCountBtn: UIButton!
    @IBOutlet weak var localNotificationBtn: UIButton!
    @IBOutlet weak var coreDataBtn: UIButton!
    @IBOutlet weak var foodDemoBtn: UIButton!
    @IBOutlet weak var mapViewBtn: UIButton!
    
    // Holds the user's name
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Set up the background video
        //        BgVideoPlay.shared.setUpVideo(on: self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop the video when the view disappears
        //        BgVideoPlay.shared.stopVideo()
    }
    
    @IBAction func pageViewButtonTapped(_ sender: Any) {
        let mapVC = MainPageViewController.sharedIntance()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func segmentViewButtonTapped(_ sender: Any) {
        let mapVC = SegmentViewController.sharedIntance()
        mapVC.navigationItem.title = "Segment Controller"
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func collectionViewAction(_ sender: Any) {
        // Navigate to the product Collection View screen
        let productListVC = VideoViewController.sharedIntance()
        productListVC.navigationItem.title = "Video View"
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
        let labelCountVC = LabelCountAViewController.sharedInstance()
        labelCountVC.title = "Label A"
        self.navigationController?.pushViewController(labelCountVC, animated: true)
    }
    
    
    @IBAction func socialAccountBtnAction(_ sender: Any) {
        let socailVC = SocialAccountViewController.sharedIntance()
        self.navigationController?.pushViewController(socailVC, animated: true)
    }
    
    @IBAction func coreDataBtnAction(_ sender: UIButton) {
        let coreDataVC = FetchCoreDataViewController.sharedInstance()
        self.navigationController?.pushViewController(coreDataVC, animated: true)
    }
    
    @IBAction func foodCoreDataBtnAction(_ sender: UIButton) {
        let foodVC = FetchFoodCoreDataViewController.sharedInstance()
        self.navigationController?.pushViewController(foodVC, animated: true)
    }
    
    @IBAction func mapViewBtnAction(_ sender: UIButton) {
        let mapVC = MapsButtonViewController.sharedInstance()
        self.navigationController?.pushViewController(mapVC, animated: true)
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
        
    }
}
