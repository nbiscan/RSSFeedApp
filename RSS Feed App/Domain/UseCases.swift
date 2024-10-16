//
//  UseCases.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

// Protocol Definitions

protocol GetRSSFeedItemsUseCaseProtocol {
    func execute(feedId: UUID) -> [RSSItem]
}

protocol ToggleFavoriteFeedUseCaseProtocol {
    func execute(feedId: UUID)
}

protocol EnableNotificationsUseCaseProtocol {
    func execute(feedId: UUID, enable: Bool)
}

protocol AddRSSFeedUseCaseProtocol {
    func execute(url: URL) async throws -> RSSFeed
}

protocol RemoveRSSFeedUseCaseProtocol {
    func execute(feedId: UUID)
}

protocol GetRSSFeedsUseCaseProtocol {
    func execute() -> [RSSFeed]
}


// Use Case Implementations

final class GetRSSFeedsUseCase: GetRSSFeedsUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())

    func execute() -> [RSSFeed] {
        repository.getFeeds()
    }
}

final class RemoveRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())

    func execute(feedId: UUID) {
        repository.removeFeed(feedId: feedId)
    }
}

final class GetRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())

    func execute(feedId: UUID) -> [RSSItem] {
        repository.getFeedItems(feedId: feedId)
    }
}

final class ToggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())

    func execute(feedId: UUID) {
        repository.toggleFavoriteFeed(feedId: feedId)
    }
}

final class EnableNotificationsUseCase: EnableNotificationsUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())

    func execute(feedId: UUID, enable: Bool) {
        repository.toggleNotifications(feedId: feedId, enable: enable)
    }
}

final class AddRSSFeedUseCase: AddRSSFeedUseCaseProtocol {
    let repository: RSSFeedRepositoryProtocol = RSSFeedRepository(service: RSSFeedService())
    
    func execute(url: URL) async throws -> RSSFeed {
        try await repository.addFeed(url: url)
    }
}

