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
    func getLocalFeeds() -> [RSSFeed]
    func getRemoteFeeds() async throws -> [RSSFeed]
    func getFeedDetails(feedURL: URL) async throws -> RSSFeed
    func getFeedItems(feedURL: URL) async throws -> [RSSItem]
    func toggleFavoriteFeed(feedURL: URL) async
    func toggleNotifications(feedURL: URL, enable: Bool) async
}

final class RSSFeedRepository: RSSFeedRepositoryProtocol {
    private let rssFeedService: RSSFeedServiceProtocol
    private let dataSource: LocalStorageDataSource<RSSFeed>
    
    static let shared = RSSFeedRepository()
    
    init(service: RSSFeedServiceProtocol = RSSFeedService(),
         dataSource: LocalStorageDataSource<RSSFeed> = LocalStorageDataSource(storageKey: Constants.Storage.key)) {
        self.rssFeedService = service
        self.dataSource = dataSource
    }
    
    func addFeed(url: URL) async throws -> RSSFeed {
        let normalizedURL = url.normalized
        var currentFeeds = dataSource.loadEntities()
        
        guard !currentFeeds.contains(where: { $0.url == normalizedURL }) else {
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
    
    func getLocalFeeds() -> [RSSFeed] {
        return dataSource.loadEntities()
    }
    
    func getRemoteFeeds() async throws -> [RSSFeed] {
        let localFeeds = dataSource.loadEntities()
        let urls = localFeeds.map { $0.url }
        
        return try await rssFeedService.fetchAllFeeds(from: urls)
    }
    
    func getFeedDetails(feedURL: URL) async throws -> RSSFeed {
        let localFeed = dataSource.loadEntities().first { $0.url == feedURL }
        let remoteFeed = try await rssFeedService.fetchFeed(from: feedURL)
        
        var mergedFeed = remoteFeed
        guard let localFeed else {
            updateFeeds { feeds in
                if let index = feeds.firstIndex(where: { $0.url == feedURL }) {
                    feeds[index] = mergedFeed
                } else {
                    feeds.append(mergedFeed)
                }
            }
            return mergedFeed
        }
        
        mergedFeed.notificationsEnabled = localFeed.notificationsEnabled
        mergedFeed.isFavorite = localFeed.isFavorite
        
        updateFeeds { feeds in
            if let index = feeds.firstIndex(where: { $0.url == feedURL }) {
                feeds[index] = mergedFeed
            } else {
                feeds.append(mergedFeed)
            }
        }
        
        return mergedFeed
    }
    
    func getFeedItems(feedURL: URL) async throws -> [RSSItem] {
        let latestFeed = try await rssFeedService.fetchFeed(from: feedURL)
        
        return updateFeeds { feeds in
            guard let index = feeds.firstIndex(where: { $0.url == feedURL }) else {
                feeds.append(latestFeed)
                return latestFeed.items
            }
            
            let storedFeed = feeds[index]
            let newItems = latestFeed.items.filter { newItem in
                !storedFeed.items.contains(where: { $0.id == newItem.id })
            }
            
            if !newItems.isEmpty {
                feeds[index].items.append(contentsOf: newItems)
            }
            
            return feeds[index].items
        }
    }
    
    func toggleFavoriteFeed(feedURL: URL) async {
        updateFeeds { feeds in
            guard let index = feeds.firstIndex(where: { $0.url == feedURL }) else { return }
            feeds[index].isFavorite.toggle()
        }
    }
    
    func toggleNotifications(feedURL: URL, enable: Bool) async {
        updateFeeds { feeds in
            guard let index = feeds.firstIndex(where: { $0.url == feedURL }) else { return }
            feeds[index].notificationsEnabled = enable
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

