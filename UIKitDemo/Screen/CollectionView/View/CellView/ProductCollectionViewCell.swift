//
//  ProductCollectionViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 11/06/24.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets for UI elements

    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    // Property observer to configure cell when product is set
    var product: ProductListModel? {
        didSet {
            productDetailConfiguration()
        }
    }
    
    // Method called when the cell is awakened from a nib
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }

    
    // Method to configure cell with product details
    func productDetailConfiguration() {
        // Ensure product is not nil
        guard let product = product else { return }
        // Set product details to respective UI elements
        cellTitleLabel.text = product.category
        cellImageView.setImage(with: product.image) // Set product image
    }

}
