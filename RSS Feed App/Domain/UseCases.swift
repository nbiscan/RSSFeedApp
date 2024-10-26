//
//  UseCases.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//
import Foundation

// MARK: - Protocol Definitions

protocol AddRSSFeedUseCaseProtocol {
    func execute(url: URL) async throws -> RSSFeed
}

protocol RemoveRSSFeedUseCaseProtocol {
    func execute(feedURL: URL)
}

protocol GetRSSFeedsUseCaseProtocol {
    func execute() async -> [RSSFeed]
}

protocol GetRSSFeedItemsUseCaseProtocol {
    func execute(feedURL: URL) async -> [RSSItem]
}

protocol ToggleFavoriteFeedUseCaseProtocol {
    func execute(feedURL: URL) async
}

protocol ToggleNotificationsUseCaseProtocol {
    func execute(feedURL: URL, enable: Bool) async
}

// MARK: - Use Case Implementations

final class AddRSSFeedUseCase: AddRSSFeedUseCaseProtocol {
    let repository = RSSFeedRepository.shared
    
    func execute(url: URL) async throws -> RSSFeed {
        return try await repository.addFeed(url: url)
    }
}

final class RemoveRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol {
    let repository = RSSFeedRepository.shared

    func execute(feedURL: URL) {
        repository.removeFeed(url: feedURL)
    }
}

final class GetRSSFeedsUseCase: GetRSSFeedsUseCaseProtocol {
    let repository = RSSFeedRepository.shared

    func execute() async -> [RSSFeed] {
        return await repository.getFeeds()
    }
}

final class GetRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol {
    let repository = RSSFeedRepository.shared

    func execute(feedURL: URL) async -> [RSSItem] {
        return await repository.getFeedItems(feedURL: feedURL)
    }
}

final class ToggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol {
    let repository = RSSFeedRepository.shared

    func execute(feedURL: URL) async {
        await repository.toggleFavoriteFeed(feedURL: feedURL)
    }
}

final class ToggleNotificationsUseCase: ToggleNotificationsUseCaseProtocol {
    let repository = RSSFeedRepository.shared

    func execute(feedURL: URL, enable: Bool) async {
        await repository.toggleNotifications(feedURL: feedURL, enable: enable)
    }
}
