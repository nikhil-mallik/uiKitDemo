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
    
    weak var delegate: LabelCountUpdateDelegate?
    var startingCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLbl.alpha = 0
        setButtonTitle()
    }
        
    @IBAction func incrementBtnAction(_ sender: Any) {
        startingCount += 1
        delegate?.updateCount(startingCount)
    }
    @IBAction func decrementBtnAction(_ sender: Any) {
        startingCount -= 1
        delegate?.updateCount(startingCount)
    }
    
    @IBAction func navigateBtnAction(_ sender: Any) {
        let labelCVC = CountCViewController.sharedInstance()
        labelCVC.delegate = delegate
        labelCVC.startingCount = startingCount
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
