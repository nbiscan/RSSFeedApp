//
//  ContentView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import SwiftUI

struct ContentView: View {
    init() {
        requestNotificationPermission()
    }
    
    var body: some View {
        RSSFeedListView()
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

#Preview {
    ContentView()
}
