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
    
    // Method to handle button clicks
    @objc func buttonClicked(_ sender: UIButton) {
        
        let buttonIndex = sender.tag
        let buttonTitle = sender.title(for: .normal) ?? "Unknown"
        sender.isEnabled = false
        sender.alpha = 0.5 // indicate that the button is disabled
        
        
        // Check if all buttons are disabled after disabling the current button
        let allButtonsDisabled = scrollViewOutlet.subviews.compactMap({ $0 as? UIButton }).allSatisfy({ !$0.isEnabled })
        
        // If all buttons are disabled after clicking the current button
        if allButtonsDisabled {
            AlertHelper.showAlert(withTitle: "Alert", message: "All buttons are disabled.", from: self)
        } else {
            AlertHelper.showAlert(withTitle: "Alert", message: "Button '\(buttonTitle)' is disabled.", from: self)
        }
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
        let totalWidth = UIScreen.main.bounds.width - 60 // (leading -> 10 + trailing -> 10) and 40 for spacing between buttons (10 * 4)
        let buttonWidth = totalWidth / 5
        let buttonHeight: CGFloat = 50
        let horizontalSpacing: CGFloat = 10
        let verticalSpacing: CGFloat = 20
        
        var currentX: CGFloat = horizontalSpacing // Start with horizontal spacing
        var currentY: CGFloat = verticalSpacing // Start with vertical spacing
        
        for (index, buttonModel) in viewModel.totalButton.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle("\(buttonModel.count)", for: .normal)
            button.backgroundColor = .systemIndigo
            button.setTitleColor(.white, for: .normal)
            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: buttonHeight)
            button.layer.cornerRadius = buttonHeight / 4
            button.tag = index // Set tag to identify the button index
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            scrollViewOutlet.addSubview(button)
            
            currentX += buttonWidth + horizontalSpacing // Add button width and horizontal spacing
            
            // Check if the next button will exceed the width of the scroll view
            if currentX + buttonWidth > UIScreen.main.bounds.width - horizontalSpacing {
                currentX = horizontalSpacing // Reset X position for the next row
                currentY += buttonHeight + verticalSpacing // Move to the next row
            }
        }
        
        // Adjust content size of scroll view based on the last button position
        let contentHeight = currentY + buttonHeight + verticalSpacing
        scrollViewOutlet.contentSize = CGSize(width: UIScreen.main.bounds.width, height: contentHeight)
        
    }
}
