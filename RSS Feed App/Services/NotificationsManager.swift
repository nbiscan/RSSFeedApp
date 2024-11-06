//
//  NotificationsManager.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 05.11.2024..
//

import UserNotifications

protocol NotificationManagerProtocol {
    func requestPermission()
    func setDelegate()
}

final class NotificationsManager: NSObject, NotificationManagerProtocol, UNUserNotificationCenterDelegate {
    static let shared = NotificationsManager()
    
    private override init() {
        super.init()
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error {
                print("Error requesting notification authorization: \(error)")
            } else if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    func setDelegate() {
        UNUserNotificationCenter.current().delegate = self
    }
}
