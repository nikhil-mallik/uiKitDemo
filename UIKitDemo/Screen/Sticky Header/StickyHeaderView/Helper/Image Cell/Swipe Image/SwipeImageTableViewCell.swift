//
//  SwipeImageTableViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 05/07/24.
//

import UIKit

class SwipeImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageBackgroundView: UIView!
    @IBOutlet weak var swipeImageView: UIImageView!
    @IBOutlet weak var showIndexNumber: UIButton!
    
    var products: [ProductListModel] = []
    var currentIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configure views' appearance
        imageBackgroundView.clipsToBounds = false
        imageBackgroundView.layer.cornerRadius = 15
        swipeImageView.layer.cornerRadius = 10
        imageBackgroundView.backgroundColor = .systemGray6
        showIndexNumber.alpha = 0
        setupGestures()
        loadCurrentImage()
    }
    

    
    func updateIndexCount() {
        showIndexNumber.alpha = 1
        showIndexNumber.setTitle("\(currentIndex + 1 )/\(products.count)", for: .normal)
    }
    
    
    // Gestures Setup
    private func setupGestures() {
        // Swipe left Gesture
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        // Swipe Right Gesture
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
    }
    
    // Load Current Image
    func loadCurrentImage() {
        if products.isEmpty {
            swipeImageView.image = nil
        } else {
            let currentProduct = products[currentIndex]
            swipeImageView.setImage(with: currentProduct.image)
            updateIndexCount()
        }
        
    }
    
    // MARK: - Right and Left Gesture Handlers
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            currentIndex = min(currentIndex + 1, products.count - 1)
        } else if gesture.direction == .right {
            currentIndex = max(currentIndex - 1, 0)
        }
        loadCurrentImage()
    }
}
