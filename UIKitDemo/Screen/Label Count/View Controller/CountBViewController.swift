//
//  CountBViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 10/07/24.
//

import UIKit

class CountBViewController: UIViewController {
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var navigateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLbl.alpha = 0
        setButtonTitle()
    }
        
    @IBAction func incrementBtnAction(_ sender: Any) {
        NotificationCenter.default.post(name: .incrementCount, object: nil)
    }
    
    @IBAction func decrementBtnAction(_ sender: Any) {
        NotificationCenter.default.post(name: .decrementCount, object: nil)
    }
    
    @IBAction func navigateBtnAction(_ sender: Any) {
        let labelCVC = CountCViewController.sharedInstance()
        labelCVC.navigationItem.title = "Label Count C"
        self.navigationController?.pushViewController(labelCVC, animated: true)
    }
    
    func setButtonTitle() {
        incrementButton.setTitle("", for: .normal)
        decrementButton.setTitle("", for: .normal)
    }
}

// MARK: - Extension for shared instance
extension CountBViewController {
    static func sharedInstance() -> CountBViewController {
        return CountBViewController.instantiateFromStoryboard("CountBViewController")
    }
}
