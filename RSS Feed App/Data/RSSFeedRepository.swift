//
//  RSSFeedRepository.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation
import UserNotifications

protocol RSSFeedRepositoryProtocol {
    func addFeed(url: URL) async throws -> RSSFeed
    func removeFeed(url: URL)
    func getFeeds() async -> [RSSFeed]
    func getFeedDetails(feedURL: URL) async throws -> RSSFeed
    func getRSSFeedListItems() -> [RSSListItem]
    func getFeedItems(feedURL: URL) async throws -> [RSSItem]
    func toggleFavoriteFeed(feedURL: URL) async
    func toggleNotifications(feedURL: URL, enable: Bool) async
}

final class RSSFeedRepository: RSSFeedRepositoryProtocol {
    private let rssFeedService: RSSFeedServiceProtocol
    private let dataSource: LocalStorageDataSource<RSSFeed>
    
    static let shared = RSSFeedRepository()
    
    private init(service: RSSFeedServiceProtocol = RSSFeedService(),
                 dataSource: LocalStorageDataSource<RSSFeed> = LocalStorageDataSource(storageKey: "savedFeeds")) {
        self.rssFeedService = service
        self.dataSource = dataSource
    }
    
    func addFeed(url: URL) async throws -> RSSFeed {
        let normalizedURL = url.normalized
        var currentFeeds = dataSource.loadEntities()
        
        if currentFeeds.contains(where: { $0.url == normalizedURL }) {
            throw NetworkError.invalidURL
        }
        
        let newFeed = try await rssFeedService.fetchFeed(from: normalizedURL)
        currentFeeds.append(newFeed)
        dataSource.saveEntities(currentFeeds)
        
        return newFeed
    }
    
    func removeFeed(url: URL) {
        updateFeeds { feeds in
            feeds.removeAll { $0.url == url }
        }
    }
    
    func getFeeds() async -> [RSSFeed] {
        return dataSource.loadEntities()
    }
    
    func getFeedDetails(feedURL: URL) async throws -> RSSFeed {
        let latestFeed = try await rssFeedService.fetchFeed(from: feedURL)
        
        updateFeeds { feeds in
            if let index = feeds.firstIndex(where: { $0.url == feedURL }) {
                feeds[index] = latestFeed
            } else {
                feeds.append(latestFeed)
            }
        }
        
        return latestFeed
    }

    func getRSSFeedListItems() -> [RSSListItem] {
        return dataSource.loadEntities().map { .init(from: $0) }
    }
    
    func getFeedItems(feedURL: URL) async throws -> [RSSItem] {
        let latestFeed = try await rssFeedService.fetchFeed(from: feedURL)
        
        return updateFeeds { feeds in
            if let index = feeds.firstIndex(where: { $0.url == feedURL }) {
                let storedFeed = feeds[index]
                
                let newItems = latestFeed.items.filter { newItem in
                    !storedFeed.items.contains(where: { $0.id == newItem.id })
                }
                
                if !newItems.isEmpty {
                    feeds[index].items.append(contentsOf: newItems)
                }
                
                return feeds[index].items
            } else {
                feeds.append(latestFeed)
                return latestFeed.items
            }
        }
    }
    
    func toggleFavoriteFeed(feedURL: URL) async {
        updateFeeds { feeds in
            if let index = feeds.firstIndex(where: { $0.url == feedURL }) {
                feeds[index].isFavorite.toggle()
            }
        }
    }
    
    func toggleNotifications(feedURL: URL, enable: Bool) async {
        updateFeeds { feeds in
            if let index = feeds.firstIndex(where: { $0.url == feedURL }) {
                feeds[index].notificationsEnabled = enable
            }
        }
    }
}

extension RSSFeedRepository {
    @discardableResult
    private func updateFeeds<T>(with modification: (inout [RSSFeed]) -> T) -> T {
        var feeds = dataSource.loadEntities()
        let result = modification(&feeds)
        dataSource.saveEntities(feeds)
        return result
    }
}

