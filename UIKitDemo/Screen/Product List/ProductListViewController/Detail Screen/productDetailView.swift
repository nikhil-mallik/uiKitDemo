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
    @IBOutlet weak var previousProductOutletBtn: UIBarButtonItem!
    @IBOutlet weak var nextProductOutletBtn: UIBarButtonItem!
    
    // MARK: - Variables
    var viewModel = productDetailViewModel()
    var product: ProductListModel?
    var currentIndex: Int = 0
    var isLiked: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    @IBAction func previousProductBtnAction(_ sender: Any) {
        guard currentIndex > 0 else {
            print("No previous product available")
            return
        }
        // Fetch previous product details
        currentIndex -= 1
        let previousProduct = viewModel.products[currentIndex]
        // Update UI with previous product data
        product = previousProduct
        configureUI()
    }
    
    @IBAction func nextProductBtnAction(_ sender: Any) {
        guard currentIndex < viewModel.products.count - 1 else {
            print("No next product available")
            return
        }
        // Fetch next product details
        currentIndex += 1
        let nextProduct = viewModel.products[currentIndex]
        // Update UI with next product data
        product = nextProduct
        configureUI()
    }
    
    @IBAction func linkeUnlikeButtonAction(_ sender: Any) {
        // Toggle the isLiked
        isLiked!.toggle()
        
        // Store the like status in UserDefaults
        if let product = product {
            isLikedUserDefault.shared.saveLikeStatus(productId: product.id, isLiked: isLiked!)
            // Print to console for debugging
            print("Button tapped. Current like status: \(String(describing: isLiked))")
        }
        // Update the button
        updateLikeUnlikeButtons()
    }
}

// Extension for shared instance creation
extension ProductDetailsView {
    static func sharedIntance() -> ProductDetailsView {
        return ProductDetailsView.instantiateFromStoryboard("ProductDetailsView")
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
        
        // Retrieve the like status from UserDefaults
        isLiked = isLikedUserDefault.shared.getLikeStatus(for: product.id)
        
        // Updating the buttons
        updateLikeUnlikeButtons()
        updateButtonStates()
    }
    
    // Update the visibility of like and unlike buttons
    func updateLikeUnlikeButtons() {
        if isLiked == false {
            linkeUnlikeButton.setTitle("Like", for: .normal)
            linkeUnlikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            linkeUnlikeButton.setTitle("Liked", for: .normal)
            linkeUnlikeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    // Update the states of previous and next buttons
    func updateButtonStates() {
        previousProductOutletBtn.isEnabled = currentIndex > 0
        nextProductOutletBtn.isEnabled = currentIndex < viewModel.products.count - 1
    }
}
