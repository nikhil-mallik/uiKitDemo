//
//  ProfileImageCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 03/07/24.
//

import UIKit

class ProfileImageCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProfileImage()
    }

    func setupProfileImage() {
        // Make profile image circular
        coverImageView.layer.borderColor = UIColor.black.cgColor
        coverImageView.layer.borderWidth = 1.0
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 3.0
        profileImageView.backgroundColor = UIColor.lightGray
    }
}
