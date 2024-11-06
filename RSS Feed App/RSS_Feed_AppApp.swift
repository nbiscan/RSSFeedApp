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
        NotificationsManager.shared.requestPermission()
        NotificationsManager.shared.setDelegate()
        BackgroundTasksManager.shared.registerTasks()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    BackgroundTasksManager.shared.scheduleFeedRefresh()
                }
                .onChange(of: scenePhase) {
                    if scenePhase == .background {
                        BackgroundTasksManager.shared.scheduleFeedRefresh()
                    }
                }
        }
    }
}
