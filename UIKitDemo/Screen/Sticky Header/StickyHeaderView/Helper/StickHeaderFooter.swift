//
//  StickHeaderFooter.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 03/07/24.
//

import UIKit

class StickHeaderFooter: UITableViewHeaderFooterView {

    @IBOutlet weak var labelBbView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelBbView.clipsToBounds = false
        labelBbView.layer.cornerRadius = 15
    }
}
