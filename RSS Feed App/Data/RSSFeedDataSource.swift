//
//  RSSFeedDataSource.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 19.10.2024..
//

import Foundation

protocol RSSFeedDataSourceProtocol {
    func saveFeeds(_ feeds: [RSSFeed])
    func loadFeeds() -> [RSSFeed]
    func updateFeed(_ feed: RSSFeed)
}

final class RSSFeedDataSource: RSSFeedDataSourceProtocol {
    private let feedsKey = "savedFeeds"
    private let userDefaults = UserDefaults.standard
    
    func saveFeeds(_ feeds: [RSSFeed]) {
        if let data = try? JSONEncoder().encode(feeds) {
            userDefaults.set(data, forKey: feedsKey)
        }
    }
    
    func loadFeeds() -> [RSSFeed] {
        guard let data = userDefaults.data(forKey: feedsKey),
              let feeds = try? JSONDecoder().decode([RSSFeed].self, from: data) else {
            return []
        }
        return feeds
    }
    
    func updateFeed(_ feed: RSSFeed) {
        var feeds = loadFeeds()
        if let index = feeds.firstIndex(where: { $0.url == feed.url }) {
            feeds[index] = feed
            saveFeeds(feeds)
        }
    }
}
