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
    func getFeedDetails(feedURL: URL) async -> RSSFeed?
    func getRSSFeedListItems() -> [RSSListItem]
    func getFeedItems(feedURL: URL) async throws -> [RSSItem]
    func toggleFavoriteFeed(feedURL: URL) async
    func toggleNotifications(feedURL: URL, enable: Bool) async
}

final class RSSFeedRepository: RSSFeedRepositoryProtocol {
    private let rssFeedService: RSSFeedServiceProtocol
    private let dataSource: RSSFeedDataSourceProtocol

    static let shared = RSSFeedRepository(service: RSSFeedService())

    private init(service: RSSFeedServiceProtocol, dataSource: RSSFeedDataSourceProtocol = RSSFeedDataSource()) {
        self.rssFeedService = service
        self.dataSource = dataSource
    }
    
    func getFeedDetails(feedURL: URL) async -> RSSFeed? {
        do {
            let latestFeed = try await rssFeedService.fetchFeed(from: feedURL)
            var storedFeeds = dataSource.loadFeeds()
            
            if let index = storedFeeds.firstIndex(where: { $0.url == feedURL }) {
                storedFeeds[index] = latestFeed
            } else {
                storedFeeds.append(latestFeed)
            }
            
            dataSource.saveFeeds(storedFeeds)
            
            return latestFeed
        } catch {
            print("Error fetching feed from network: \(error)")
            return dataSource.loadFeeds().first { $0.url == feedURL }
        }
    }


    func addFeed(url: URL) async throws -> RSSFeed {
        let normalizedURL = normalizeURL(url)
        var currentFeeds = dataSource.loadFeeds()

        if currentFeeds.contains(where: { $0.url == normalizedURL }) {
            throw NetworkError.invalidURL
        }

        let newFeed = try await rssFeedService.fetchFeed(from: normalizedURL)
        currentFeeds.append(newFeed)
        dataSource.saveFeeds(currentFeeds)

        return newFeed
    }

    func removeFeed(url: URL) {
        var currentFeeds = dataSource.loadFeeds()
        currentFeeds.removeAll { $0.url == url }
        dataSource.saveFeeds(currentFeeds)
    }

    func getFeeds() async -> [RSSFeed] {
        return dataSource.loadFeeds()
    }
    
    func getRSSFeedListItems() -> [RSSListItem] {
        return dataSource.loadFeeds().map { .init(from: $0) }
    }
    
    func getFeedItems(feedURL: URL) async throws -> [RSSItem] {
        // Fetch the latest items from the network
        let latestFeed = try await rssFeedService.fetchFeed(from: feedURL)
        
        // Load stored feed
        var storedFeeds = dataSource.loadFeeds()
        if let index = storedFeeds.firstIndex(where: { $0.url == feedURL }) {
            let storedFeed = storedFeeds[index]
            
            // Compare and add any new items to the stored feed
            let newItems = latestFeed.items.filter { newItem in
                !storedFeed.items.contains(where: { $0.id == newItem.id })
            }
            
            if !newItems.isEmpty {
                storedFeeds[index].items.append(contentsOf: newItems) // Update storage with new items
                dataSource.saveFeeds(storedFeeds)
            }
            
            // Return the updated list of items (including newly fetched ones)
            return storedFeeds[index].items
        } else {
            // If the feed isn’t in storage yet, add it
            storedFeeds.append(latestFeed)
            dataSource.saveFeeds(storedFeeds)
            return latestFeed.items
        }
    }


    func toggleFavoriteFeed(feedURL: URL) async {
        var feeds = dataSource.loadFeeds()
        if let index = feeds.firstIndex(where: { $0.url == feedURL }) {
            feeds[index].isFavorite.toggle()
            dataSource.updateFeed(feeds[index])
        }
    }

    func toggleNotifications(feedURL: URL, enable: Bool) async {
        var feeds = dataSource.loadFeeds()
        if let index = feeds.firstIndex(where: { $0.url == feedURL }) {
            feeds[index].notificationsEnabled = enable
            dataSource.updateFeed(feeds[index])
        }
    }

    private func normalizeURL(_ url: URL) -> URL {
        guard url.scheme == nil else { return url }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        return components?.url ?? url
    }
}
