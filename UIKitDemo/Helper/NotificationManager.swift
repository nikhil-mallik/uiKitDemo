//
//  NotificationManager.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 15/07/24.
//

import UIKit
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSendNotification), name: .sendNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .sendNotification, object: nil)
    }
    
    @objc private func handleSendNotification(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let title = userInfo["title"] as? String,
              let body = userInfo["body"] as? String,
              let hours = userInfo["hours"] as? Int,
              let minutes = userInfo["minutes"] as? Int,
              let isDaily = userInfo["isDaily"] as? Bool else { return }
        
        checkNotificationPermission { granted in
            if granted {
                self.customNotification(withTitle: title, withBody: body, hours: hours, minutes: minutes, repeatDaily: isDaily)
            } else {
                // Handle the case when permission is denied
                print("Permission denied for notifications")
            }
        }
    }
    
    private func customNotification(withTitle title: String, withBody body: String, hours: Int, minutes: Int, repeatDaily isDaily: Bool) {
        let identifier = "\(title)-Notification"
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = .init(value: +1)
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hours
        dateComponents.minute = minutes
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
    
     func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { didAllow, error in
                    DispatchQueue.main.async {
                        completion(didAllow)
                    }
                }
            case .denied:
                DispatchQueue.main.async {
                    completion(false)
                }
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    completion(true)
                }
            @unknown default:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}

extension Notification.Name {
    static let sendNotification = Notification.Name("sendNotification")
}
