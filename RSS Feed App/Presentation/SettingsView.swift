//
//  SettingsView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 24.10.2024..
//

import SwiftUI
struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel = .init()
    
    var body: some View {
        NavigationView {
            List(viewModel.feeds, id: \.url) { feed in
                HStack {
                    Text(feed.title)
                    
                    Spacer()
                    
                    Toggle(isOn: Binding(
                        get: { feed.notificationsEnabled },
                        set: { newValue in
                            viewModel.toggleNotifications(for: feed, isEnabled: newValue)
                        })
                    ) {
                        Text("")
                    }
                    .labelsHidden()
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Toggle Notifications")
            .task {
                await viewModel.loadFeeds()
            }
        }
    }
}

#Preview {
    SettingsView()
}
