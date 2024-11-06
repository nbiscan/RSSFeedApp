//
//  GetRSSFeedItemsUseCase.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol GetRSSFeedItemsUseCaseProtocol {
    func execute(feedURL: URL) async throws -> [RSSItem]
}

extension GetRSSFeedItemsUseCaseProtocol {
    func callAsFunction(feedURL: URL) async throws -> [RSSItem] {
        try await execute(feedURL: feedURL)
    }
}

final class GetRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol {
    let repository = RSSFeedRepository.shared

    func execute(feedURL: URL) async throws -> [RSSItem] {
        return try await repository.getFeedItems(feedURL: feedURL)
    }
}

final class MockGetRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol {
    var result: [RSSItem] = [.mock]
    func execute(feedURL: URL) async throws -> [RSSItem] {
        return result
    }
}
