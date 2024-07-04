//
//  LoaderHelper.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 24/06/24.
//

import UIKit

class LoaderViewHelper {
    private static var loaderView: UIView?
    
    // MARK: - Show Loader on View
    static func showLoaderView(on view: UIView) {
        hideLoader() // Ensure any previous loader is removed
        
        let loaderSize: CGFloat = 60
        let loaderView = UIView(frame: CGRect(x: 0, y: 0, width: loaderSize, height: loaderSize))
        loaderView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        loaderView.layer.cornerRadius = loaderSize / 2
        loaderView.center = view.center
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor.white
        activityIndicator.center = CGPoint(x: loaderSize / 2, y: loaderSize / 2)
        activityIndicator.startAnimating()
        
        loaderView.addSubview(activityIndicator)
        view.addSubview(loaderView)
        
        self.loaderView = loaderView
    }
    
    // MARK: - Show Loader on Button
    static func showLoader(on button: UIButton) {
        hideLoader() // Ensure any previous loader is removed
        button.isEnabled = false
        let loaderSize: CGFloat = 30
        let loaderView = UIView(frame: CGRect(x: 0, y: 0, width: loaderSize, height: loaderSize))
        loaderView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        loaderView.layer.cornerRadius = loaderSize / 2
        loaderView.center = CGPoint(x: button.bounds.midX, y: button.bounds.midY)
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = UIColor.white
        activityIndicator.center = CGPoint(x: loaderSize / 2, y: loaderSize / 2)
        activityIndicator.startAnimating()
        
        loaderView.addSubview(activityIndicator)
        button.addSubview(loaderView)
        
        self.loaderView = loaderView
    }
    
    // MARK: - Hide Loader
    static func hideLoader() {
        loaderView?.removeFromSuperview()
        loaderView = nil
    }
}
