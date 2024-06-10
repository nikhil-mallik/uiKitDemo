//
//  Utility.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 07/06/24.
//

import UIKit

class Utility {
       
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 75/255, green: 0/255, blue: 130/255, alpha: 1).cgColor

        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    // Function to set the loading state of a button
    static func setButtonLoadingState(button: UIButton, isLoading: Bool) {
            var configuration = button.configuration?.updated(for: button)
            configuration?.showsActivityIndicator = isLoading
            button.configuration = configuration
        }
    
    
}
