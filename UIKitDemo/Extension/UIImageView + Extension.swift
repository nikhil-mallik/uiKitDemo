//
//  UIImageView + Extension.swift
//  Youtube MVVM Products
//
//  Created by Yogesh Patel on 23/12/22.
//

import UIKit
import Alamofire

// MARK: - UIImageView Extension
extension UIImageView {
    // Method to set an image from a URL string
    func setImage(with urlString: String) {
        // Step 1: Create the URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL string") // Log an error if the URL string is invalid
            return
        }
        
        // Step 2: Optionally show an activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        // Start the activity indicator animation
        activityIndicator.startAnimating()
        // Center the activity indicator
        activityIndicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        // Add the activity indicator to the UIImageView
        self.addSubview(activityIndicator)
        
        // Step 3: Make the network request
        AF.request(url).responseData { response in
            
            // Step 4: Handle the response
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    // Set the image if the data is valid
                    self.image = image
                } else {
                    print("Failed to create image from data")
                }
            case .failure(let error):
                print("Failed to load image: \(error)")
            }
            // Remove the activity indicator once the request is complete
            activityIndicator.removeFromSuperview()
        }
    }
}
