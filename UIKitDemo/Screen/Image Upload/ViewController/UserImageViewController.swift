//
//  UserImageViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 25/06/24.
//

import UIKit

class UserImageViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var AddImageButton: UIBarButtonItem!
    @IBOutlet weak var userImageCollectionView: UICollectionView!
    @IBOutlet weak var floatingBtnOutlet: UIButton!
    
    // MARK: - Variables
    private  var viewImage: [UIImage] = []
    var imagePickerHelper: ImagePickerHelper?
    var pickedImage: UIImage?
    var isListEnable: Bool? = false

    override func viewDidLoad() {
        super.viewDidLoad()
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
                // Reload the collection view to display the new image
                self?.userImageCollectionView.reloadData()
            }
        }
    }
    
    @IBAction func floatingBtnAction(_ sender: Any) {
        isListEnable!.toggle()
        floatingBtnTitle()
    }
}

// MARK: - Extension for shared instance
extension UserImageViewController {
    static func sharedIntance() -> UserImageViewController {
        return UserImageViewController.instantiateFromStoryboard("UserImageViewController")
    }
    
    // MARK: - Helper Methods
    func floatingBtnTitle() {
        if isListEnable == false {
            floatingBtnOutlet.setTitle("", for: .normal)
            floatingBtnOutlet.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        } else {
            floatingBtnOutlet.setTitle("", for: .normal)
            floatingBtnOutlet.setImage(UIImage(systemName: "tablecells"), for: .normal)
        }
        self.userImageCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension UserImageViewController : UICollectionViewDataSource {
    
    // Method to return the number of items in a section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewImage.count
    }
    
    // Method to configure and return the cell for an item at a specific index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UserImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let image = viewImage[indexPath.row]
        cell.setImage(image)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserImageViewController: UICollectionViewDelegateFlowLayout {
    // Method to return the size for an item at a specific index path
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let showCollectionView = (collectionView.frame.size.width - 20) / 2 // Width for collection view
        let showListView = collectionView.frame.size.width  // width for list view
        let width = isListEnable! ? showListView : showCollectionView
        let height = (collectionView.frame.size.width - 40) / 2 // fixed height
        return CGSize(width: width, height: height)
    }
}
