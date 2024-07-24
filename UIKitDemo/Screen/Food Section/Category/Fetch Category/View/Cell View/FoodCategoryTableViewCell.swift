//
//  FoodCategoryTableViewCell.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 17/07/24.
//

import UIKit

class FoodCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelBgView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
        categoryName.text = (category.categoryName ?? "")
        dateLabel.text = "Created at: \(getDateOnly(from: category.createdAt ?? Date()))"
    }
    // Convert date to string format
    func getDateOnly(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
