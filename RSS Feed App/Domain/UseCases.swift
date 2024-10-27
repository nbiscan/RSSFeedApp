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
    func execute(feedURL: URL) async throws -> [RSSItem]
}

protocol ToggleFavoriteFeedUseCaseProtocol {
    func execute(feedURL: URL) async
}

protocol ToggleNotificationsUseCaseProtocol {
    func execute(feedURL: URL, enable: Bool) async
}

protocol GetRSSFeedDetailsUseCaseProtocol {
    func execute(feedURL: URL) async -> RSSFeed?
}

protocol GetRSSFeedListUseCaseProtocol {
    func execute() -> [RSSListItem]
}

final class GetRSSFeedListUseCase: GetRSSFeedListUseCaseProtocol {
    private let repository: RSSFeedRepositoryProtocol = RSSFeedRepository.shared

    func execute() -> [RSSListItem] {
        return repository.getRSSFeedListItems()
    }
}

final class GetRSSFeedDetailsUseCase: GetRSSFeedDetailsUseCaseProtocol {
    let repository = RSSFeedRepository.shared

    func execute(feedURL: URL) async -> RSSFeed? {
        return await repository.getFeedDetails(feedURL: feedURL)
    }
}
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

    func execute(feedURL: URL) async throws -> [RSSItem] {
        return try await repository.getFeedItems(feedURL: feedURL)
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


// mocks

final class MockAddRSSFeedUseCase: AddRSSFeedUseCaseProtocol {
    var result: RSSFeed = .mock
    func execute(url: URL) async throws -> RSSFeed {
        return result
    }
}

final class MockRemoveRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol {
    func execute(feedURL: URL) { }
}

final class MockGetRSSFeedListUseCase: GetRSSFeedListUseCaseProtocol {
    var result: [RSSListItem] = []
    func execute() -> [RSSListItem] {
        return result
    }
}

final class MockToggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol {
    func execute(feedURL: URL) async { }
}

final class MockGetRSSFeedDetailsUseCase: GetRSSFeedDetailsUseCaseProtocol {
    var result: RSSFeed?
    
    func execute(feedURL: URL) async -> RSSFeed? {
        return result
    }
}

final class MockToggleNotificationsUseCase: ToggleNotificationsUseCaseProtocol {
    var receivedFeedURL: URL?
    var receivedIsEnabled: Bool?
    
    func execute(feedURL: URL, enable: Bool) async {
        receivedFeedURL = feedURL
        receivedIsEnabled = enable
    }
}
