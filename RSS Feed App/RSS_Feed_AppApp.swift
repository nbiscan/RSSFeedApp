//
//  RSS_Feed_AppApp.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import SwiftUI

@main
struct RSS_Feed_AppApp: App {
    init() {
        requestNotificationPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
}
