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
    var alertItem: AlertItem?
    
    private let getRSSFeedDetailsUseCase: GetRSSFeedDetailsUseCaseProtocol
    private let toggleNotificationsUseCase: ToggleNotificationsUseCaseProtocol
    
    init(feedURL: URL,
         getRSSFeedDetailsUseCase: GetRSSFeedDetailsUseCaseProtocol = GetRSSFeedDetailsUseCase(),
         toggleNotificationsUseCase: ToggleNotificationsUseCaseProtocol = ToggleNotificationsUseCase()
    ) {
        self.feedURL = feedURL
        self.getRSSFeedDetailsUseCase = getRSSFeedDetailsUseCase
        self.toggleNotificationsUseCase = toggleNotificationsUseCase
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
