//
//  UserImageScrollViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 25/06/24.
//

import UIKit

class UserImageScrollViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var AddImageButton: UIBarButtonItem!
    @IBOutlet weak var floatingBtnOutlet: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageNotFoundLbl: UILabel!
    
    // MARK: - Variables
    private  var viewImage: [UIImage] = []
    var imagePickerHelper: ImagePickerHelper?
    var pickedImage: UIImage?
    var isListEnable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatingButton()
        setupNoImageFoundLabel()
        floatingBtnTitle()
    }
    
    // MARK: - Actions
    @IBAction func addImageAction(_ sender: Any) {
        imagePickerHelper = ImagePickerHelper()
        imagePickerHelper?.presentImagePicker(in: self) { [weak self] selectedImage in
            if let image = selectedImage {
                self?.pickedImage = image
                // Add the selected image to the array
                self?.viewImage.append(image)
                self?.setupNoImageFoundLabel()
                self?.layoutImages()
                self?.adjustFloatingButtonPosition()
            }
        }
    }
    
    @IBAction func floatingBtnAction(_ sender: Any) {
        isListEnable.toggle()
        floatingBtnTitle()
    }
    
    // MARK: - Image tapped Method
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageFullVC = FullScreenImageViewControllers.sharedIntance()
        guard let index = sender.view?.tag else { return }
        imageFullVC.images = viewImage
        imageFullVC.currentIndex = index
        navigationController?.pushViewController(imageFullVC, animated: true)
    }
    
    // Show/Hide No Image found label
    func setupNoImageFoundLabel() {
        if viewImage.isEmpty {
            imageNotFoundLbl.alpha = 1
            scrollView.isScrollEnabled = false
            let labelHeight = imageNotFoundLbl.bounds.height
            let scrollViewHeight = scrollView.bounds.height
            let yOffset = (scrollViewHeight - labelHeight) / 2.0
            imageNotFoundLbl.frame.origin.y = yOffset
            scrollView.addSubview(imageNotFoundLbl)
        } else {
            imageNotFoundLbl.alpha = 0
            scrollView.isScrollEnabled = true
        }
    }
}

// MARK: - Extension for shared instance
extension UserImageScrollViewController {
    static func sharedIntance() -> UserImageScrollViewController {
        return UserImageScrollViewController.instantiateFromStoryboard("UserImageScrollViewController")
    }
}

// MARK: - Add Image Function
extension UserImageScrollViewController {
    private func layoutImages() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        scrollView.addSubview(imageNotFoundLbl)
        let spacing: CGFloat = 5
        let totalWidth = scrollView.frame.width
        var contentHeight: CGFloat = 0
        
        if isListEnable {
            let fixedHeight: CGFloat = 200
            var yOffset: CGFloat = 0
            
            for (index, image) in viewImage.enumerated() {
                let itemWidth = totalWidth
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.frame = CGRect(x: 0, y: yOffset, width: itemWidth, height: fixedHeight)
                scrollView.addSubview(imageView)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGesture)
                imageView.tag = index
                
                yOffset += fixedHeight + spacing
                contentHeight = yOffset
            }
            scrollView.contentSize = CGSize(width: totalWidth, height: contentHeight)
        } else {
            let itemsPerRow: CGFloat = 5
            let itemWidth = (totalWidth - (itemsPerRow - 1) * spacing) / itemsPerRow
            var xOffset: CGFloat = 0
            var yOffset: CGFloat = 0
            
            for (index, image) in viewImage.enumerated() {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemWidth)
                scrollView.addSubview(imageView)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGesture)
                imageView.tag = index
                
                xOffset += itemWidth + spacing
                
                if (index + 1).isMultiple(of: Int(itemsPerRow)) {
                    xOffset = 0
                    yOffset += itemWidth + spacing
                }
            }
            let rows = ceil(Double(viewImage.count) / Double(itemsPerRow))
            contentHeight = CGFloat(rows) * (itemWidth + spacing)
            scrollView.contentSize = CGSize(width: totalWidth, height: contentHeight)
        }
        adjustFloatingButtonPosition()
    }
}

// MARK: - Extension for FloatingButton
extension UserImageScrollViewController {
    // Setup Image
    
    func floatingBtnTitle() {
        if isListEnable == false {
            floatingBtnOutlet.setTitle("", for: .normal)
            floatingBtnOutlet.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        } else {
            floatingBtnOutlet.setTitle("", for: .normal)
            floatingBtnOutlet.setImage(UIImage(systemName: "tablecells"), for: .normal)
        }
        layoutImages()
    }
    
    // Contraints of Floating Button
    private func setupFloatingButton() {
        // Constrain floating button to the safe area bottom
        floatingBtnOutlet.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floatingBtnOutlet)
        floatingBtnOutlet.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floatingBtnOutlet)
        floatingBtnOutlet.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        floatingBtnOutlet.widthAnchor.constraint(equalToConstant: 50).isActive = true // Set width to 50 points
        floatingBtnOutlet.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        floatingBtnOutlet.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // floating button is always above scrollView
        view.bringSubviewToFront(floatingBtnOutlet)
    }
    
    // floating button stays at bottom of safe area and above scrollView content
    private func adjustFloatingButtonPosition() {
        let floatingBtnHeight: CGFloat = 50
        let floatingBtnY = view.safeAreaInsets.bottom + 20
        
        // Animate button position change
        UIView.animate(withDuration: 0.2) {
            // Adjust button position based on scrollView content size
            let maxContentHeight = self.scrollView.contentSize.height
            let scrollViewHeight = self.scrollView.frame.height
            
            if maxContentHeight > scrollViewHeight {
                // Content height exceeds scrollView height, button at fixed bottom
                self.floatingBtnOutlet.frame.origin.y = self.view.frame.height - floatingBtnHeight - floatingBtnY
            } else {
                // Content height fits within scrollView height, button scrolls with content
                self.floatingBtnOutlet.frame.origin.y = maxContentHeight - floatingBtnHeight + floatingBtnY
            }
        }
    }
}
