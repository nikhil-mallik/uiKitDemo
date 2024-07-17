//
//  UserCoreDataTableViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 16/07/24.
//

import UIKit

class UserCoreDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellbackgroundView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var dobLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var bioDataLbl: UILabel!
    
    var user: UserEntity? {
        didSet {
            userConfiguration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // Configure views' appearance
        cellbackgroundView.clipsToBounds = false
        cellbackgroundView.layer.cornerRadius = 15
        userImageView.layer.cornerRadius = 10
        cellbackgroundView.backgroundColor = .systemGray6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func userConfiguration() {
        guard let user else { return }
        fullNameLbl.text = "Name: " + (user.firstName ?? "") + " " + (user.lastName ?? " " )
        emailLbl.text = "Email: \(user.email ?? " ")"
        dobLbl.text = "DOB: " + getDateOnly(from: user.dob ?? Date())
        numberLbl.text = "Number: \(user.mobileNumber)"
        bioDataLbl.text = "Bio-Data: " + (user.bioData ?? " ")
        guard let imageURL = FileManagerHelper.getImageURL(for: user.userImage) else {
            print("Invalid image name.")
            return
        }
        userImageView.image = UIImage(contentsOfFile: imageURL.path)
    }
    
    // Convert date to string format
    func getDateOnly(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}
