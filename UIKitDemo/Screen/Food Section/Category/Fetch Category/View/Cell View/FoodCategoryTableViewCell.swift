//
//  FoodCategoryTableViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 17/07/24.
//

import UIKit

class FoodCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var labelBgView: UIView!
    
    var category: CategoryEntity? {
        didSet {
            categoryConfiguration()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        labelBgView.clipsToBounds = false
        labelBgView.layer.cornerRadius = 15
        labelBgView.backgroundColor = .systemGray6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func categoryConfiguration() {
        guard let category else { return }
        categoryName.text = (category.catName ?? "")
    }
}
