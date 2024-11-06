//
//  RSS_Feed_AppApp.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//
import SwiftUI
import BackgroundTasks
import UserNotifications

@main
struct RSS_Feed_AppApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        requestNotificationPermission()
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        RSSBackgroundManager.shared.registerBackgroundTasks()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    RSSBackgroundManager.shared.scheduleFeedRefresh()
                }
                .onChange(of: scenePhase) {
                    if scenePhase == .background {
                        RSSBackgroundManager.shared.scheduleFeedRefresh()
                    }
                }
        }
    }
    
    private func requestNotificationPermission() {
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
}
