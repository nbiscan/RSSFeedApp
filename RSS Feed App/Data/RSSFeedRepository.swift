//
//  RSSFeedRepository.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol RSSFeedRepositoryProtocol {
    func addFeed(url: URL) async throws -> RSSFeed
    func removeFeed(feedId: UUID)
    func getFeeds() -> [RSSFeed]
    func getFeedItems(feedId: UUID) -> [RSSItem]
    func toggleFavoriteFeed(feedId: UUID)
    func toggleNotifications(feedId: UUID, enable: Bool)
}

final class RSSFeedRepository: RSSFeedRepositoryProtocol {
    private var storage: [RSSFeed] = []
    private let rssFeedService: RSSFeedServiceProtocol
    
    init(service: RSSFeedServiceProtocol) {
        self.rssFeedService = service
    }
    
    deinit {
        print("RSSFeedRepository deinit")
    }
    
    func addFeed(url: URL) async throws -> RSSFeed {
        let newFeed = try await rssFeedService.fetchFeed(from: url)
        storage.append(newFeed)
        
        return newFeed
    }
    
    func removeFeed(feedId: UUID) {
        storage.removeAll(where: { $0.id == feedId })
    }
    
    func getFeeds() -> [RSSFeed] {
        storage
    }
    
    func getFeedItems(feedId: UUID) -> [RSSItem] {
        storage.first(where: { $0.id == feedId })?.items ?? []
    }
    
    func toggleFavoriteFeed(feedId: UUID) {
        let feedIndex: Int? = storage.firstIndex(where: { $0.id == feedId })
        
        if let feedIndex {
            storage[feedIndex].isFavorite.toggle()
        }
    }
    
    func toggleNotifications(feedId: UUID, enable: Bool) {
        if let index = storage.firstIndex(where: { $0.id == feedId }) {
            storage[index].notificationsEnabled = enable
        }
    }
}
