//
//  ButtonViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 14/06/24.
//

import UIKit

class ButtonViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBgView: UIView!
    
    
    @IBOutlet weak var cellButton: UIButton!
    
    // Property observer to configure cell when count is set
    var addButtonModel: AddButtonModel? {
        didSet {
            totalCountConfiguration()
        }
    }
    
    // Method called when the cell is awakened from a nib
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // Method to configure cell with product details
    func totalCountConfiguration() {
        // Ensure count is not nil
        guard let addButtonModel = addButtonModel else { return }
        // Set count UI elements
        cellButton.setTitle("\(addButtonModel.count)", for: .normal)
    }

}
