//
//  CountCViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 10/07/24.
//

import UIKit

class CountCViewController: UIViewController {
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var navigateHomeBtn: UIButton!
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
    
    @IBAction func navigateHomeBtnAction(_ sender: Any) {
        if let navigationController = self.navigationController {
            for viewController in navigationController.viewControllers {
                if viewController is LabelCountAViewController {
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
    
    func setButtonTitle() {
        incrementButton.setTitle("", for: .normal)
        decrementButton.setTitle("", for: .normal)
    }
    
}

// MARK: - Extension for shared instance
extension CountCViewController {
    static func sharedInstance() -> CountCViewController {
        return CountCViewController.instantiateFromStoryboard("CountCViewController")
    }
}
