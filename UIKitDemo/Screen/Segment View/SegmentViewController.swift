//
//  SegmentViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 30/07/24.
//

import UIKit

class SegmentViewController: UIViewController {
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var firstContainerView: UIView!
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var thirdContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showFirstContainer()
    }
    
    func showFirstContainer() {
        firstContainerView.isHidden = false
        secondContainerView.isHidden = true
        thirdContainerView.isHidden = true
    }
    
    func showSecondContainer() {
        firstContainerView.isHidden = true
        secondContainerView.isHidden = false
        thirdContainerView.isHidden = true
    }
    
    func showThirdContainer() {
        firstContainerView.isHidden = true
        secondContainerView.isHidden = true
        thirdContainerView.isHidden = false
    }
    
    @IBAction func segmentActions(_ sender: Any) {
        switch segmentController.selectedSegmentIndex {
        case 0:
            showFirstContainer()
        case 1:
            showSecondContainer()
        case 2:
            showThirdContainer()
        default:
            break
        }
        
    }
}

// MARK: - Extension
extension SegmentViewController {
    // Create an instance of ViewController from storyboard
    static func sharedIntance() -> SegmentViewController {
        return SegmentViewController.instantiateFromStoryboard("SegmentViewController")
    }
}
