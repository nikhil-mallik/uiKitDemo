//
//  UserListCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 10/06/24.
//

import UIKit

import UIKit

// MARK: - UserListCell Class
class UserListCell: UITableViewCell {
    // Outlets for UI elements
    @IBOutlet weak var userBackgroundView: UIView! // Background view
    @IBOutlet weak var userId: UILabel! // User ID label
    @IBOutlet weak var userTitle: UILabel! // User title label
    @IBOutlet weak var userStatus: UILabel! // User status label
    
    // Model for the cell
    var modelUser: UserListModel? {
        didSet {
            userConfiguration()
        }
    }

    // Method called when the cell is awakened from a nib
    override func awakeFromNib() {
        super.awakeFromNib()
        userBackgroundView.clipsToBounds = false
        userBackgroundView.layer.cornerRadius = 15
        backgroundColor = .systemGray6
    }

    // Method called when the cell is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state (no action needed in this case)
    }
    
    // Method to configure the cell with user data
    func userConfiguration() {
        // Get status color tuple from the model
        let status = modelUser?.getStatusColor()
        // Set user status label text and status label color based on status
        userStatus.text = status?.0
        userStatus.textColor = status?.1
        // Set user ID label text with model's ID or "No ID" if ID is nil
        if let id = modelUser?.id {
            userId.text = "\(id)"
        } else {
            userId.text = "No ID"
        }
        // Set user title label text with model's title
        userTitle.text = modelUser?.title
    }
}
