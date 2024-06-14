//
//  AddButtonViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 13/06/24.
//

import UIKit

class AddButtonViewController: UIViewController {
    
    @IBOutlet weak var NumberLabelOutlet: UILabel!
    @IBOutlet weak var numberInputOutlet: UITextField!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var TableViewOutlet: UICollectionView!
    
    // MARK: - Variables
    private var viewModel = AddButtonViewModel()
    
    //ButtonViewCell
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        guard let numberText = numberInputOutlet.text, !numberText.isEmpty else {
            AlertHelper.showAlert(withTitle: "Alert", message: "Please enter a number.", from: self)
            return
        }
        
        guard let number = Int(numberText) else {
            AlertHelper.showAlert(withTitle: "Alert", message: "Invalid input. Please enter a valid integer.", from: self)
            return
        }
        
        viewModel.updateButtonCount(to: number)
        TableViewOutlet.reloadData()
    }
    
}

// Extension for shared instance creation
extension AddButtonViewController {
    static func sharedIntance() -> AddButtonViewController {
        return AddButtonViewController.instantiateFromStoryboard("AddButtonViewController")
    }
}


// MARK: - UICollectionViewDataSource
extension AddButtonViewController : UICollectionViewDataSource {
    
    // Method to return the number of items in a section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.totalButton.count
    }
    
    // Method to configure and return the cell for an item at a specific index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonViewCell", for: indexPath) as? ButtonViewCell else {
            return UICollectionViewCell()
        }
        let buttons = viewModel.totalButton[indexPath.row]
        cell.addButtonModel = buttons
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension AddButtonViewController: UICollectionViewDelegateFlowLayout {
    // Method to return the size for an item at a specific index path
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 20) / 2
        return CGSize(width: size, height: size)
    }
}
