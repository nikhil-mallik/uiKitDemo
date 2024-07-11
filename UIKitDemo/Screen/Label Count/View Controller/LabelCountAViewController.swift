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
    let viewModel = LabelCountViewModel.shared
    private var observation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonTitle()
        observeTasks()
    }
    
    func observeTasks() {
        observation = viewModel.observe(\.counts?.labelCount, options: [.new, .old]) { [weak self] (_, change) in
            guard let newCount = change.newValue!,
                  let oldCount = change.oldValue! else {
                return
            }
            self?.countLbl.text = "\(newCount)"
            print("Old value: \(oldCount)")
        }
    }
    
    @IBAction func incrementBtnAction(_ sender: Any) {
        viewModel.addCount()
    }
    @IBAction func decrementBtnAction(_ sender: Any) {
        viewModel.subtractCount()
    }
    
    @IBAction func navigateBtnAction(_ sender: Any) {
        let LabelBVC = CountBViewController.sharedIntance()
        LabelBVC.navigationItem.title = "Label Count B"
        self.navigationController?.pushViewController(LabelBVC, animated: true)
    }
    
    func setButtonTitle() {
        incrementButton.setTitle("", for: .normal)
        decrementButton.setTitle("", for: .normal)
    }
    
}

// MARK: - Extension for shared instance
extension LabelCountAViewController {
    static func sharedIntance() -> LabelCountAViewController {
        return LabelCountAViewController.instantiateFromStoryboard("LabelCountAViewController")
    }
}
