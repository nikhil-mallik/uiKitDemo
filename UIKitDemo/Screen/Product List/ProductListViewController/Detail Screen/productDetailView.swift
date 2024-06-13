//
//  productDetailView.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 13/06/24.
//

import UIKit

class ProductDetailsView : UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productRatingButton: UIButton!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var linkeUnlikeButton: UIButton!
    @IBOutlet weak var productPriceLabel: UILabel!
    var isLiked: Bool = false

    // MARK: - Variables
    private var viewModel = productDetailViewModel()
    var product: ProductListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
//                staticData()
    }
    
    // Configure UI elements with product data
    func configureUI() {
        guard let product = product else { return }
        print(product.description)
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
            linkeUnlikeButton.setTitle("Like", for: .normal)
//            linkeUnlikeButton.setImage(UIImage(named: "heart"), for: .normal)
        } else {
            linkeUnlikeButton.setTitle("Liked", for: .normal)
//            linkeUnlikeButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        }
    }
    
    func staticData() {
        guard let product = product else { return }
        
        productTitle.text = "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday --> RS"
        productCategory.text = product.category
        productDescription.text = "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday --> Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday --> RS"
        productPriceLabel.text = "$\(product.price)"
        productRatingButton.setTitle("\(product.rating.rate)", for: .normal)
        productImage.setImage(with: product.image)
        updateLikeUnlikeButtons()
    }
    
    
    @IBAction func linkeUnlikeButtonAction(_ sender: Any) {
        // Toggle the isLiked
        isLiked.toggle()
        
        // Update the button
        updateLikeUnlikeButtons()
        
        // Print to console for debugging
        print("Button tapped. Current like status: \(isLiked)")
    }
    
}

// Extension for shared instance creation
extension ProductDetailsView {
    static func sharedIntance() -> ProductDetailsView {
        return ProductDetailsView.instantiateFromStoryboard("ProductDetailsView")
    }
}
