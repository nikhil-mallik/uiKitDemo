//
//  LabelCountAViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 10/07/24.
//

import UIKit

class LabelCountAViewController: UIViewController {
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var navigateBtn: UIButton!
    private var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonTitle()
        // observeTasks()
        updateCountLabel()
        observeNotifications()
    }
    
    func updateCount(_ count: Int) {
        self.count = count
        updateCountLabel()
    }
    
    
    func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(incrementCount(_:)), name: .incrementCount, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(decrementCount(_:)), name: .decrementCount, object: nil)
    }
    
    @objc func incrementCount(_ notification: Notification) {
        count += 1
        print("Count => \(count)")
        updateCountLabel()
    }
    
    @objc func decrementCount(_ notification: Notification) {
        count -= 1
        print("Count => \(count)")
        updateCountLabel()
    }
    
    func updateCountLabel() {
        countLbl.text = "\(count)"
    }
    
    /*    func observeTasks() {
     NotificationCenter.default.addObserver(self, selector: #selector(countDidChange(_:)), name: .countDidChange, object: nil)
     }
     
     @objc func countDidChange(_ notification: Notification) {
     if let newCount = notification.userInfo?["newCount"] as? Int {
     countLbl.text = "\(newCount)"
     }
     }*/
    
    @IBAction func incrementBtnAction(_ sender: Any) {
        count += 1
        updateCountLabel()
    }
    @IBAction func decrementBtnAction(_ sender: Any) {
        count -= 1
        updateCountLabel()
    }
    
    @IBAction func navigateBtnAction(_ sender: Any) {
        let labelBVC = CountBViewController.sharedInstance()
        labelBVC.navigationItem.title = "Label Count B"
        self.navigationController?.pushViewController(labelBVC, animated: true)
    }
    
    func setButtonTitle() {
        incrementButton.setTitle("", for: .normal)
        decrementButton.setTitle("", for: .normal)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - Extension for shared instance
extension LabelCountAViewController {
    static func sharedInstance() -> LabelCountAViewController {
        return LabelCountAViewController.instantiateFromStoryboard("LabelCountAViewController")
    }
}

extension Notification.Name {
    static let incrementCount = Notification.Name("incrementCount")
    static let decrementCount = Notification.Name("decrementCount")
}


