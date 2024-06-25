//
//  UserImageCollectionViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 25/06/24.
//

import UIKit

class UserImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlet
    @IBOutlet weak var imageView: UIImageView!
    
    // Method to set the image
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set the image view to fill the cell
        imageView.contentMode = .scaleAspectFill
    }
}
