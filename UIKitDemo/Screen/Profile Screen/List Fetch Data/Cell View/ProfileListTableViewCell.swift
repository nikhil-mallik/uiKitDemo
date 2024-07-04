//
//  ProfileListTableViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 04/07/24.
//

import UIKit

class ProfileListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userBackgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var userDetail: ProfileModel? {
        didSet {
            userDetailConfiguration()
        }
    }
    
    // Method called when the cell is awakened from a nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configure views' appearance
        userBackgroundView.clipsToBounds = false
        userBackgroundView.layer.cornerRadius = 15
        profileImageView.layer.cornerRadius = 10
        self.userBackgroundView.backgroundColor = .systemGray6
    }
    
    func userDetailConfiguration() {
        guard let user = userDetail else { return }
        nameLabel.text = "Name: " + user.firstNames + " " + user.lastNames
        emailLabel.text = "Email: " + user.email
        mobileLabel.text = "Mobile: " + user.mobileNumbers
        dobLabel.text = "DOB: " + getDateOnly(from: user.dob)
        addressLabel.text = "Address: " + user.address
        profileImageView.image = user.profileImages
    }
    
    // Convert date to string format
    func getDateOnly(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}
