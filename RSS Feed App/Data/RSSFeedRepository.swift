//
//  RSSFeedRepository.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol RSSFeedRepositoryProtocol {
    func addFeed(url: URL) async throws -> RSSFeed
    func removeFeed(url: URL)
    func getFeeds() async -> [RSSFeed]
    func getFeedItems(feedURL: URL) async -> [RSSItem]
    func toggleFavoriteFeed(feedURL: URL) async
    func toggleNotifications(feedURL: URL, enable: Bool) async
}
final class RSSFeedRepository: RSSFeedRepositoryProtocol {
    private let rssFeedService: RSSFeedServiceProtocol
    private let dataSource: RSSFeedDataSourceProtocol

    init(service: RSSFeedServiceProtocol, dataSource: RSSFeedDataSourceProtocol = RSSFeedDataSource()) {
        self.rssFeedService = service
        self.dataSource = dataSource
    }

    deinit {
        print("RSSFeedRepository deinit")
    }

    func addFeed(url: URL) async throws -> RSSFeed {
        let normalizedURL = normalizeURL(url)

        let currentURLs = dataSource.loadFeedURLs()
        if currentURLs.contains(normalizedURL) {
            throw NSError(domain: "RSSFeedRepositoryError",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "This URL has already been added."])
        }

        let newFeed = try await rssFeedService.fetchFeed(from: normalizedURL)
        var updatedURLs = currentURLs
        updatedURLs.append(normalizedURL)
        dataSource.saveFeedURLs(updatedURLs)

        return newFeed
    }

    func removeFeed(url: URL) {
        if dataSource.isFavoriteURL(url) {
            dataSource.removeFavoriteURL(url)
        }

        dataSource.removeFeedURL(url)
    }

    func getFeeds() async -> [RSSFeed] {
        let feedURLs = dataSource.loadFeedURLs()
        var feeds: [RSSFeed] = []
        
        for url in feedURLs {
            do {
                let feed = try await rssFeedService.fetchFeed(from: url)
                print("Fetched feed: \(feed.url)")
                
                let isFavorite = dataSource.isFavoriteURL(feed.url)
                let notificationsEnabled = dataSource.loadNotificationSettings(for: feed.url)
                
                let updatedFeed = RSSFeed(
                    title: feed.title,
                    description: feed.description,
                    imageUrl: feed.imageUrl,
                    url: feed.url,
                    isFavorite: isFavorite,
                    notificationsEnabled: notificationsEnabled,
                    items: feed.items
                )
                
                feeds.append(updatedFeed)
            } catch {
                print("Failed to fetch feed from URL: \(url), error: \(error)")
            }
        }
        
        return feeds
    }

    func getFeedItems(feedURL: URL) async -> [RSSItem] {
        guard let feed = await getFeeds().first(where: { $0.url == feedURL }) else {
            return []
        }
        return feed.items
    }
    
    func toggleFavoriteFeed(feedURL: URL) async {
        if dataSource.isFavoriteURL(feedURL) {
            dataSource.removeFavoriteURL(feedURL)
        } else {
            dataSource.addFavoriteURL(feedURL)
        }
    }
    
    func toggleNotifications(feedURL: URL, enable: Bool) async {
        dataSource.saveNotificationSettings(for: feedURL, isEnabled: enable)
    }
    
    private func normalizeURL(_ url: URL) -> URL {
        guard url.scheme == nil else { return url }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        return components?.url ?? url
    }
}
