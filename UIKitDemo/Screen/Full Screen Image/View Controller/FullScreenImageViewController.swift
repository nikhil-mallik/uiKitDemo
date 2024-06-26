//
//  FullScreenImageViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 25/06/24.
//

import UIKit

class FullScreenImageViewControllers: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var lableTxtOutlet: UILabel!
    
    // MARK: - Variable
    var images: [UIImage] = []
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupImageView()
        setupGestures()
        loadCurrentImage()
    }
    func setupLabelText() {
        lableTxtOutlet.alpha = 0
        lableTxtOutlet.text = "\(currentIndex + 1)/\(images.count)"
    }
    // MARK: - Setup Methods
    // Scroll View Setup
    private func setupScrollView() {
        scrollViewOutlet.delegate = self
        scrollViewOutlet.minimumZoomScale = 1.0
        scrollViewOutlet.maximumZoomScale = 6.0
        scrollViewOutlet.showsHorizontalScrollIndicator = false
        scrollViewOutlet.showsVerticalScrollIndicator = false
        scrollViewOutlet.bouncesZoom = true
    }
    // Image Setup
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
    }
    
    // Gestures Steup
    private func setupGestures() {
        // Swipe left Gesture
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        // Swipe Right Gesture
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        // Double Tap Gesture
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        // Pinch Gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        scrollViewOutlet.addGestureRecognizer(pinchGesture)
    }
    
    // Load Current Image
    private func loadCurrentImage() {
        imageView.image = images[currentIndex]
        let imageWidth = view.frame.width
        let aspectRatio = imageView.image!.size.height / imageView.image!.size.width
        let imageHeight = imageWidth * aspectRatio
        imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        scrollViewOutlet.contentSize = imageView.frame.size
        scrollViewOutlet.zoomScale = 1.0
        
        // Center the image if it's smaller than the scrollView height
        centerImageView()
        setupLabelText()
        
    }
    
    // Center the Image View
    private func centerImageView() {
        //        let offsetX = max((scrollViewOutlet.bounds.size.width - scrollViewOutlet.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollViewOutlet.bounds.size.height - scrollViewOutlet.contentSize.height) * 0.5, 0.0)
        imageView.center = CGPoint(x: scrollViewOutlet.contentSize.width * 0.5 /*+ offsetX*/, y: scrollViewOutlet.contentSize.height * 0.5 + offsetY)
        
//        // Position label below the image
//        let labelY = imageView.frame.maxY + 10
//        lableTxtOutlet.frame = CGRect(x: 0, y: labelY, width: view.frame.width, height: lableTxtOutlet.frame.height)
//        lableTxtOutlet.textAlignment = .center
    }
    
    // MARK: - Right and Left Gesture Handlers
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            currentIndex = min(currentIndex + 1, images.count - 1)
        } else if gesture.direction == .right {
            currentIndex = max(currentIndex - 1, 0)
        }
        loadCurrentImage()
    }
    
    // MARK: - Double Gesture Handlers
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollViewOutlet.zoomScale == scrollViewOutlet.minimumZoomScale {
            scrollViewOutlet.setZoomScale(scrollViewOutlet.maximumZoomScale, animated: true)
        } else {
            scrollViewOutlet.setZoomScale(scrollViewOutlet.minimumZoomScale, animated: true)
        }
    }
    
    // MARK: - Pinch Gesture Handlers
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        scrollViewOutlet.setZoomScale(scrollViewOutlet.zoomScale * gesture.scale, animated: true)
        gesture.scale = 1.0
    }
}

// MARK: - Extension for shared instance
extension FullScreenImageViewControllers {
    static func sharedIntance() -> FullScreenImageViewControllers {
        return FullScreenImageViewControllers.instantiateFromStoryboard("FullScreenImageViewControllers")
    }
}

// MARK: - UIScrollViewDelegate
extension FullScreenImageViewControllers: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageView()
    }
}
