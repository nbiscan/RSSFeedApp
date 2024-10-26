//
//  RSSFeedDetailsViewModel.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 26.10.2024..
//

import SwiftUI

@Observable
final class RSSFeedDetailsViewModel: ObservableObject {
    let feed: RSSFeed
    var notificationsEnabled: Bool {
        didSet {
            toggleNotifications()
        }
    }
    private let toggleNotificationsUseCase: ToggleNotificationsUseCaseProtocol = ToggleNotificationsUseCase()
    
    init(feed: RSSFeed) {
        self.feed = feed
        self.notificationsEnabled = feed.notificationsEnabled
    }
    
    func toggleNotifications() {
        Task {
            await toggleNotificationsUseCase.execute(feedURL: feed.url, enable: notificationsEnabled)
        }
    }
}
