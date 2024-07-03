//
//  FetchProfileTableViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 03/07/24.
//

import UIKit

class FetchProfileTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var profileData: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up table view properties
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        
        registerCell()
        fetchProductData()
    }
}

// MARK: - Extension for shared instance
extension FetchProfileTableViewController {
    static func sharedIntance() -> FetchProfileTableViewController {
        return FetchProfileTableViewController.instantiateFromStoryboard("FetchProfileTableViewController")
    }
}

// MARK: - Extension of Helper Method
extension FetchProfileTableViewController {
    
    // Register custom cells
    func registerCell() {
        tableView.register(UINib(nibName: "ProfileImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        tableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        tableView.register(UINib(nibName: "ProfileBioDataCell", bundle: nil), forCellReuseIdentifier: "BioDataCell")
        tableView.register(UINib(nibName: "ProfileButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
    }
    
    // Fetch and reload profile data
    func fetchProductData() {
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc func editButtonAction() {
        let profileVC = AddProfileViewController.sharedIntance()
        profileVC.profileInfo = profileData
        profileVC.isProfileEditing = true
        navigationController?.pushViewController(profileVC, animated: true)
        print("Edit")
    }
    
    // Convert date to string format
    func getDateOnly(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

// MARK: - UITableViewDataSource
extension FetchProfileTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Image cell
        case 1:
            return 7 // Profile info cells
        case 2:
            return 2 // Bio Data Cell
        case 3:
            return 1 // Button cell
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ProfileImageCell
            cell.profileImageView.image = profileData?.profileImages
            cell.coverImageView.image = profileData?.coverImages
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! ProfileInfoCell
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Full Name :"
                cell.dataLabel.text = "\(profileData?.firstNames ?? "") \(profileData?.lastNames ?? "")"
            case 1:
                cell.titleLabel.text = "Email :"
                cell.dataLabel.text = profileData?.email
            case 2:
                cell.titleLabel.text = "Mobile Number :"
                cell.dataLabel.text = profileData?.mobileNumbers
            case 3:
                cell.titleLabel.text = "Date of Birth :"
                cell.dataLabel.text = getDateOnly(from: profileData?.dob ?? Date())
            case 4:
                cell.titleLabel.text = "Country :"
                cell.dataLabel.text = profileData?.countryName.name
            case 5:
                cell.titleLabel.text = "State :"
                cell.dataLabel.text = profileData?.stateName.name
            case 6:
                cell.titleLabel.text = "City :"
                cell.dataLabel.text = profileData?.cityName
            default:
                break
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BioDataCell", for: indexPath) as! ProfileBioDataCell
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Address :"
                cell.dataLabel.text = profileData?.address
            case 1:
                cell.titleLabel.text = "Bio Data :"
                cell.dataLabel.text = profileData?.bioData
            default:
                break
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ProfileButtonCell
            cell.editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension FetchProfileTableViewController:  UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
}
