//
//  ProductDetailsViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 11/06/24.
//


import UIKit
// Not UseFul Code
class ProductDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productRatingButton: UIButton!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    var isLiked: Bool = false
    
    // MARK: - Variables
    private var viewModel = productDetailViewModel()
    var product: ProductListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // Configure UI elements with product data
    func configureUI() {
        guard let product = product else { return }
        
        // Update UI elements with product data
        productTitle.text = product.title
        productCategory.text = product.category
        productDescription.text = product.description
        productPriceLabel.text = "$\(product.price)"
        productRatingButton.setTitle("\(product.rating.rate)", for: .normal)
        productImage.setImage(with: product.image)
        updateLikeUnlikeButtons()
    }
    
    // Update the visibility of like and unlike buttons
    func updateLikeUnlikeButtons() {
            if isLiked == false {
                likeButton.isHidden = false
                unlikeButton.isHidden = true
            } else {
                likeButton.isHidden = true
                unlikeButton.isHidden = false
            }
        }
    
    // Action for unlike button
    @IBAction func unlikeButtonAction(_ sender: Any) {
        isLiked = true
        updateLikeUnlikeButtons()
        print("unlike tapped")
    }
    
    // Action for like button
    @IBAction func likeButtonAction(_ sender: Any) {
        isLiked = false
        updateLikeUnlikeButtons()
        print("like tapped")
    }
}

// Extension for shared instance creation
extension ProductDetailsViewController {
    static func sharedIntance() -> ProductDetailsViewController {
        return ProductDetailsViewController.instantiateFromStoryboard("ProductDetailsViewController")
    }
}
