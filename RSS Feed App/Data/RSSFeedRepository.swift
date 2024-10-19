//
//  RSSFeedRepository.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

import Foundation

protocol RSSFeedRepositoryProtocol {
    func addFeed(url: URL) async throws -> RSSFeed
    func removeFeed(url: URL)
    func getFeeds() async -> [RSSFeed]
    func getFeedItems(feedURL: URL) async -> [RSSItem]
    //    func toggleFavoriteFeed(feedURL: URL) async
    //    func toggleNotifications(feedURL: URL, enable: Bool) async
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
        let currentURLs = dataSource.loadFeedURLs()
        if currentURLs.contains(url) {
            throw NSError(domain: "RSSFeedRepositoryError", code: 1, userInfo: [NSLocalizedDescriptionKey: "This URL has already been added."])
        }

        let newFeed = try await rssFeedService.fetchFeed(from: url)
        var updatedURLs = currentURLs
        updatedURLs.append(url)
        dataSource.saveFeedURLs(updatedURLs)

        return newFeed
    }

    func removeFeed(url: URL) {
        dataSource.removeFeedURL(url)
    }

    func getFeeds() async -> [RSSFeed] {
        let feedURLs = dataSource.loadFeedURLs()
        var feeds: [RSSFeed] = []
        
        for url in feedURLs {
            do {
                let feed = try await rssFeedService.fetchFeed(from: url)
                print("Fetched feed: \(feed.url)")
                
                if !feeds.contains(where: { $0.url == feed.url }) {
                    feeds.append(feed)
                } else {
                    print("Duplicate feed found: \(feed.url)")
                }
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
}
