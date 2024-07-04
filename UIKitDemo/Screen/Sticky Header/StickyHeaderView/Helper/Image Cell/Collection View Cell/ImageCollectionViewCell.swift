//
//  ImageCollectionViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 04/07/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(with url: String) {
          imageView.setImage(with: url)
      }

}
