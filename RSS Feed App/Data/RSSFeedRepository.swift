//
//  RSSFeedRepository.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol RSSFeedRepositoryProtocol {
    func addFeed(url: URL) -> RSSFeed
    func removeFeed(feedId: UUID)
    func getFeeds() -> [RSSFeed]
    func getFeedItems(feedId: UUID) -> [RSSItem]
    func toggleFavoriteFeed(feedId: UUID)
    func toggleNotifications(feedId: UUID, enable: Bool)
}

final class RSSFeedRepository: RSSFeedRepositoryProtocol {
    private var storage: [RSSFeed] = []
    
    deinit {
        print("RSSFeedRepository deinit")
    }
    
    func addFeed(url: URL) -> RSSFeed {
        let newFeed: RSSFeed = .init(id: UUID(),
                                     title: "",
                                     description: "",
                                     imageUrl: nil,
                                     url: url,
                                     isFavorite: false,
                                     notificationsEnabled: false,
                                     items: [])
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
