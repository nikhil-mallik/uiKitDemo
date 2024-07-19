//
//  NotificationManager.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 15/07/24.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: - Singleton Instance
    static let shared = NotificationManager()
    
    // MARK: - Private Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Initialization
    private override init() {
        super.init()
        registerForSendNotification()
        notificationCenter.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .sendNotification, object: nil)
    }
    
    // MARK: - Register for Notification
    private func registerForSendNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSendNotification(_:)), name: .sendNotification, object: nil)
    }
    
    // MARK: - Notification Handler
    @objc private func handleSendNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let title = userInfo["title"] as? String,
              let body = userInfo["body"] as? String else {
            return
        }
        
        let hours = userInfo["hours"] as? Int ?? 11
        let minutes = userInfo["minutes"] as? Int ?? 0
        let isDaily = userInfo["isDaily"] as? Bool ?? false
        let date = userInfo["date"] as? Date ?? Date()
        
        checkNotificationPermission { granted in
            if granted {
                DispatchQueue.main.sync {
                    self.scheduleNotification(withTitle: title, body: body, date: date, hours: hours, minutes: minutes, repeatDaily: isDaily)
                }
            } else {
                print("Permission denied for notifications")
            }
        }
    }
    
    // MARK: - Schedule Notification
    private func scheduleNotification(withTitle title: String, body: String, date: Date, hours: Int, minutes: Int, repeatDaily isDaily: Bool) {
        let identifier = "\(title)-Notification"
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.hour = hours
        dateComponents.minute = minutes
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
    
    // MARK: - Notification Permission Check
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completion: completion)
            case .denied:
                completion(false)
            case .authorized, .provisional, .ephemeral:
                completion(true)
            @unknown default:
                completion(false)
            }
        }
    }
    
    // MARK: - Request Authorization
    private func requestAuthorization(completion: @escaping (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    // MARK: - Clear Badge
    func clearBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // Handle tap on notification or clear from notification center
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        clearBadge()
        completionHandler()
    }
    
    // Handle notification delivery when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        completionHandler([.alert, .sound, .badge])
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let sendNotification = Notification.Name("sendNotification")
}
