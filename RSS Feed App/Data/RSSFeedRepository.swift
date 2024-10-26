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
    func getFeedDetails(feedURL: URL) async -> RSSFeed?
    func getRSSFeedListItems() -> [RSSListItem]
    func getFeedItems(feedURL: URL) async -> [RSSItem]
    func toggleFavoriteFeed(feedURL: URL) async
    func toggleNotifications(feedURL: URL, enable: Bool) async
    func scheduleNotification(for feed: RSSFeed, item: RSSItem)
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
        let allFeeds = dataSource.loadFeeds()
        return allFeeds.first { $0.url == feedURL }
    }

    func addFeed(url: URL) async throws -> RSSFeed {
        let normalizedURL = normalizeURL(url)
        var currentFeeds = dataSource.loadFeeds()

        if currentFeeds.contains(where: { $0.url == normalizedURL }) {
            throw NSError(domain: "RSSFeedRepositoryError",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "This URL has already been added."])
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

    func getFeedItems(feedURL: URL) async -> [RSSItem] {
        guard let feed = await getFeeds().first(where: { $0.url == feedURL }) else {
            return []
        }
        return feed.items
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

import UserNotifications

extension RSSFeedRepository {
    func scheduleNotification(for feed: RSSFeed, item: RSSItem) {
        guard feed.notificationsEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = feed.title
        content.body = item.title
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: item.id.absoluteString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // TODO: change interval
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
