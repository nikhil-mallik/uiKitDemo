//
//  FetchProfileViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 02/07/24.
//

import UIKit

//class FetchProfileViewController: UIViewController {
//    
//    @IBOutlet weak var contentView: UIView!
//    @IBOutlet weak var scrollableHeight: NSLayoutConstraint!
//    @IBOutlet weak var dataCoverImage: UIImageView!
//    @IBOutlet weak var dataProfileImage: UIImageView!
//    @IBOutlet weak var dataName: UILabel!
//    @IBOutlet weak var dataMobileNumber: UILabel!
//    @IBOutlet weak var dataDOB: UILabel!
//    @IBOutlet weak var dataEmailID: UILabel!
//    @IBOutlet weak var dataCountryName: UILabel!
//    @IBOutlet weak var dataStateName: UILabel!
//    @IBOutlet weak var dataCityName: UILabel!
//    @IBOutlet weak var dataAddress: UILabel!
//    @IBOutlet weak var dataBioData: UILabel!
//    @IBOutlet weak var editButton: UIButton!
//    
//    var profileData: ProfileModel?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupProfileImage()
//        fetchProductData()
//    }
//    
//    func setupProfileImage() {
//        // Make profile image circular
//        dataProfileImage.layer.cornerRadius = dataProfileImage.frame.size.width / 2
//        dataProfileImage.clipsToBounds = true
//        dataProfileImage.layer.borderColor = UIColor.black.cgColor
//        dataProfileImage.layer.borderWidth = 3.0
//    }
//    
//    func getDateOnly(from date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter.string(from: date)
//        return dateString
//    }
//    
//    func fetchProductData() {
//        guard let profile = profileData else { return }
//        let fullName = profile.firstNames + " " + profile.lastNames
//        dataCoverImage.image = profile.coverImages
//        dataProfileImage.image = profile.profileImages
//        dataName.text = fullName
//        dataEmailID.text = profile.email
//        dataMobileNumber.text = profile.mobileNumbers
//        dataBioData.text = profile.bioData
//        dataDOB.text = getDateOnly(from: profile.dob)
//        dataAddress.text = profile.address
//        dataCountryName.text = profile.countryName.name
//        dataStateName.text = profile.stateName.name
//        dataCityName.text = profile.cityName
//
//        adjustScrollableHeight()
//    }
//    
//    func adjustScrollableHeight() {
//
//        // Trigger layout pass to ensure all constraints are calculated
//            contentView.setNeedsLayout()
//            contentView.layoutIfNeeded()
//
//            // Calculate the required height using systemLayoutSizeFitting with proper width constraint
//            let targetSize = CGSize(width: contentView.frame.width, height: UIView.layoutFittingCompressedSize.height)
//            let contentSize = contentView.systemLayoutSizeFitting(targetSize,
//                                                                  withHorizontalFittingPriority: .required,
//                                                                  verticalFittingPriority: .fittingSizeLevel)
//
//            // Set the height constraint to the calculated height
//            scrollableHeight.constant = contentSize.height
//            contentView.layoutIfNeeded() // Ensure the new height is applied
//       
//     
//        print("contentSize.height => \(contentSize.height)")
//        print("scrollableHeight.constant => \(scrollableHeight.constant)")
//       
//
//    }
//    
//    @IBAction func editButtonAction(_ sender: UIButton) {
//        let profileVC = AddProfileViewController.sharedIntance()
//        profileVC.profileInfo = profileData
//        profileVC.isProfileEditing = true
//        navigationController?.pushViewController(profileVC, animated: true)
//        print("Edit")
//    }
//    
//}
//
//// MARK: - Extension for shared instance
//extension FetchProfileViewController {
//    static func sharedIntance() -> FetchProfileViewController {
//        return FetchProfileViewController.instantiateFromStoryboard("FetchProfileViewController")
//    }
//    
//}
