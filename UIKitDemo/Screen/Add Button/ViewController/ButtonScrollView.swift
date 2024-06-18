//
//  ButtonScrollView.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 14/06/24.
//

import UIKit

class ButtonScrollView: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var generateNumberLbl: UILabel!
    @IBOutlet weak var enterNumberTxt: UITextField!
    @IBOutlet weak var submitBtnOutlet: UIButton!
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    // MARK: - Variables
    private var viewModel = AddButtonViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Action
    @IBAction func submitBtnAction(_ sender: Any) {
        guard let numberText = enterNumberTxt.text, !numberText.isEmpty else {
            AlertHelper.showAlert(withTitle: "Alert", message: "Please enter a number.", from: self)
            return
        }
        guard let number = Int(numberText), number >= 1 else {
            AlertHelper.showAlert(withTitle: "Alert", message: "Invalid input. Please enter a valid number.", from: self)
            return
        }
        viewModel.updateButtonCount(to: number)
        setupButtons()
    }
}


// Extension for shared instance creation
extension ButtonScrollView {
    static func sharedIntance() -> ButtonScrollView {
        return ButtonScrollView.instantiateFromStoryboard("ButtonScrollView")
    }
    
    // Method to setup buttons in the scroll view
    private func setupButtons() {
        // Remove existing buttons
        scrollViewOutlet.subviews.forEach { $0.removeFromSuperview() }
        
        // Calculate button size and spacing
        let buttonWidth: CGFloat = 60
        let buttonHeight: CGFloat = 50
        let horizontalSpacing: CGFloat = 10
        let verticalSpacing: CGFloat = 20
        
        var currentX: CGFloat = horizontalSpacing // Start with horizontal spacing
        var currentY: CGFloat = verticalSpacing // Start with vertical spacing
        
        for (_, buttonModel) in viewModel.totalButton.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle("\(buttonModel.count)", for: .normal)
            button.backgroundColor = .systemIndigo
            button.setTitleColor(.white, for: .normal)
            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: buttonHeight)
            scrollViewOutlet.addSubview(button)
            
            currentX += buttonWidth + horizontalSpacing // Add button width and horizontal spacing
            
            // Check if the next button will exceed the width of the scroll view
            if currentX + buttonWidth > scrollViewOutlet.contentSize.width {
                currentX = horizontalSpacing // Reset X position for the next row
                currentY += buttonHeight + verticalSpacing // Move to the next row
            }
        }
        
        // Adjust content size of scroll view based on the last button position
        let contentWidth = max(scrollViewOutlet.frame.size.width, currentX)
        scrollViewOutlet.contentSize = CGSize(width: contentWidth, height: currentY + buttonHeight + verticalSpacing)
    }
}
