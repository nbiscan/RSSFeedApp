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
            Task {
                await toggleNotifications()
            }
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
        defer {
            loading = false
        }
                
        do {
            let fetchedFeed = try await getRSSFeedDetailsUseCase(feedURL: feedURL)
            
            notificationsEnabled = fetchedFeed.notificationsEnabled
            feed = fetchedFeed
        } catch {
            alertItem = .init(message: error.localizedDescription)
        }
    }
    
    private func toggleNotifications() async {
        guard let feed else { return }
        await toggleNotificationsUseCase(feedURL: feed.url, enable: notificationsEnabled)
    }
}

extension RSSFeedDetailsViewModel: Equatable {
    public static func == (lhs: RSSFeedDetailsViewModel, rhs: RSSFeedDetailsViewModel) -> Bool {
        return lhs.feedURL == rhs.feedURL
    }
}

extension RSSFeedDetailsViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(feedURL)
    }
}
