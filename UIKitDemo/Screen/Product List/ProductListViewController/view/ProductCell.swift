//
//  ProductCell.swift
//  Youtube MVVM Products
//
//  Created by Yogesh Patel on 23/12/22.
//

import UIKit

import UIKit

// MARK: - ProductCell Class
class ProductCell: UITableViewCell {
    // MARK: - Outlets for UI elements
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productBackgroundView: UIView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel! 
    
    // Property observer to configure cell when product is set
    var product: ProductListModel? {
        didSet {
            productDetailConfiguration()
        }
    }

    // Method called when the cell is awakened from a nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configure views' appearance
        productBackgroundView.clipsToBounds = false
        productBackgroundView.layer.cornerRadius = 15
        productImageView.layer.cornerRadius = 10
        self.productBackgroundView.backgroundColor = .systemGray6
    }

    // Method called when the cell is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // No action needed when selected
    }

    // Method to configure cell with product details
    func productDetailConfiguration() {
        // Ensure product is not nil
        guard let product = product else { return }
        // Set product details to respective UI elements
        productTitleLabel.text = product.title
        productCategoryLabel.text = product.category
        descriptionLabel.text = product.description
        priceLabel.text = "$\(product.price)"
        rateButton.setTitle("\(product.rating.rate)", for: .normal)
        productImageView.setImage(with: product.image) // Set product image
    }
}

