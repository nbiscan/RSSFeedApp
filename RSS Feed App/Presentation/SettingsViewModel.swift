//
//  SettingsViewModel.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 24.10.2024..
//

import SwiftUI

@Observable
final class SettingsViewModel: ObservableObject {
    var feeds: [RSSFeed] = []
    
    private let getRSSFeedsUseCase: GetRSSFeedsUseCaseProtocol = GetRSSFeedsUseCase()
    private let toggleNotificationsUseCase: ToggleNotificationsUseCaseProtocol = ToggleNotificationsUseCase()
        
    func loadFeeds() async {
        feeds = await getRSSFeedsUseCase.execute()
    }
    
    func toggleNotifications(for feed: RSSFeed, isEnabled: Bool) {
        if let index = feeds.firstIndex(where: { $0.url == feed.url }) {
            feeds[index].notificationsEnabled = isEnabled
            Task {
                await toggleNotificationsUseCase.execute(feedURL: feed.url, enable: isEnabled)
            }
        }
    }
}
