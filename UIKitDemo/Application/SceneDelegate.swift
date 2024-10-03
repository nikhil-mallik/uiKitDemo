//
//  SceneDelegate.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 06/06/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        // Initialize the NotificationManager
        _ = NotificationManager.shared
        _ = LocationPermissionManager.shared
        
//        BiometricHelper.shared.authenticateUser { [weak self]  in
//            guard let self = self else { return }
            
            if TokenService.tokenShared.checkForLogin() {
                let vc = TabbarViewController.sharedIntance()
                let navVC = UINavigationController(rootViewController: vc)
                self.window?.rootViewController = navVC
            } else {
                let rootVC = TabbarViewController.sharedIntance() //ViewController.sharedIntance()
                let navVC = UINavigationController(rootViewController: rootVC)
                self.window?.rootViewController = navVC
            }
            
            // Check for notification permissions
            NotificationManager.shared.checkNotificationPermission { granted in
                if granted {
                    print("Notification permissions granted")
                } else {
                    print("Notification permissions denied")
                }
            }
            
            LocationPermissionManager.shared.requestCurrentLocation { location in
                if let location = location {
                    print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    // Use the location here
                } else {
                    print("Failed to get location.")
                    // Handle the failure case
                }
            }
            
            self.window?.makeKeyAndVisible()
            UNUserNotificationCenter.current().delegate = self
//        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    
    // Clear badge when notification is opened
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
    
    // Clear badge when notification is delivered (optional)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler([.alert, .sound, .badge])
    }
}
