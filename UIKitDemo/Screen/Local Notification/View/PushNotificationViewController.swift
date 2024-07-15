//
//  PushNotificationViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 15/07/24.
//

import UIKit

class PushNotificationViewController: UIViewController {
    
    @IBOutlet weak var titleTxtFd: UITextField!
    @IBOutlet weak var bodyTxtFd: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toggleBtn: UISwitch!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    var hour: Int?
    var mins: Int?
    var isRepeating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        byDefaultHoursAndMins()
        isRepeating = false
        updateUI()
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        hour = components.hour
        mins = components.minute
        updateUI()
    }
    
    func byDefaultHoursAndMins() {
        // Set initial values from date picker
        let components = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
        hour = components.hour
        mins = components.minute
    }
    
    func updateUI() {
        // Update UI elements based on current values
        toggleBtn.isOn = isRepeating
    }
       
    @IBAction func toggleSwitchAction(_ sender: UISwitch) {
        isRepeating = sender.isOn
        updateUI()
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        postNotifications()
    }
    
    func postNotifications() {
        guard let title = titleTxtFd.text, !title.isEmpty,
              let body = bodyTxtFd.text, !body.isEmpty,
              let hours = hour,
              let min = mins
        else {
            AlertHelper.showAlert(withTitle: "Alert", message: "All fields are required", from: self)
            return
        }
        NotificationCenter.default.post(name: .sendNotification, object: nil, userInfo: [
            "title": title,
            "body": body,
            "hours": hours,
            "minutes": min,
            "isDaily": isRepeating
        ])
        clearField()
    }
    
    func clearField() {
        titleTxtFd.text = ""
        bodyTxtFd.text = ""
        byDefaultHoursAndMins()
        isRepeating = false
        updateUI()
    }
}

// MARK: - Extension for shared instance
extension PushNotificationViewController {
    static func sharedInstance() -> PushNotificationViewController {
        return PushNotificationViewController.instantiateFromStoryboard("PushNotificationViewController")
    }
}

