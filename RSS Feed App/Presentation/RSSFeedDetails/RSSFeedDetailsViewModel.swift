//
//  RSSFeedDetailsViewModel.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 26.10.2024..
//

import SwiftUI

@Observable
final class RSSFeedDetailsViewModel: ObservableObject {
    private let feedURL: URL
    var feed: RSSFeed?
    var notificationsEnabled: Bool = false {
        didSet {
            toggleNotifications()
        }
    }
    var loading: Bool = false
    
    private let getRSSFeedDetailsUseCase: GetRSSFeedDetailsUseCaseProtocol = GetRSSFeedDetailsUseCase()
    private let toggleNotificationsUseCase: ToggleNotificationsUseCaseProtocol = ToggleNotificationsUseCase()
    
    init(feedURL: URL) {
        self.feedURL = feedURL
    }
    
    func loadFeedDetails() async {
        loading = true
        feed = await getRSSFeedDetailsUseCase.execute(feedURL: feedURL)
        notificationsEnabled = feed?.notificationsEnabled ?? false
        
        loading = false
    }
    
    private func toggleNotifications() {
        guard let feed = feed else { return }
        Task {
            await toggleNotificationsUseCase.execute(feedURL: feed.url, enable: notificationsEnabled)
        }
    }
}
