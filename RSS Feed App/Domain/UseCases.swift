//
//  UseCases.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

// Protocols

protocol GetRSSFeedItemsUseCaseProtocol {
    func execute(feedURL: URL) async -> [RSSItem]
}

protocol ToggleFavoriteFeedUseCaseProtocol {
    func execute(feedURL: URL) async
}

protocol EnableNotificationsUseCaseProtocol {
    func execute(feedURL: URL, enable: Bool) async
}

protocol AddRSSFeedUseCaseProtocol {
    func execute(url: URL) async throws -> RSSFeed
}

protocol RemoveRSSFeedUseCaseProtocol {
    func execute(feedURL: URL)
}

protocol GetRSSFeedsUseCaseProtocol {
    func execute() async -> [RSSFeed]
}

// Use Case Implementations

final class GetRSSFeedsUseCase: GetRSSFeedsUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())

    func execute() async -> [RSSFeed] {
        return await repository.getFeeds()
    }
}

final class RemoveRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())

    func execute(feedURL: URL) {
        print("Removing URL: \(feedURL.absoluteString)")
        repository.removeFeed(url: feedURL)
    }
}

final class GetRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())

    func execute(feedURL: URL) async -> [RSSItem] {
        return await repository.getFeedItems(feedURL: feedURL)
    }
}

final class ToggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())

    func execute(feedURL: URL) async {
        await repository.toggleFavoriteFeed(feedURL: feedURL)
    }
}

//final class EnableNotificationsUseCase: EnableNotificationsUseCaseProtocol {
//    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())
//
//    func execute(feedURL: URL, enable: Bool) async { // Updated to async
//        await repository.toggleNotifications(feedURL: feedURL, enable: enable) // Awaiting async method
//    }
//}

final class AddRSSFeedUseCase: AddRSSFeedUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())
    
    func execute(url: URL) async throws -> RSSFeed {
        return try await repository.addFeed(url: url)
    }
}
