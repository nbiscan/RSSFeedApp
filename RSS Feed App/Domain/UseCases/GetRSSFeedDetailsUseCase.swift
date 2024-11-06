//
//  GetRSSFeedDetailsUseCase.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol GetRSSFeedDetailsUseCaseProtocol {
    func execute(feedURL: URL) async throws -> RSSFeed
}

extension GetRSSFeedDetailsUseCaseProtocol {
    func callAsFunction(feedURL: URL) async throws -> RSSFeed {
        return try await execute(feedURL: feedURL)
    }
}

final class GetRSSFeedDetailsUseCase: GetRSSFeedDetailsUseCaseProtocol {
    private let repository: RSSFeedRepositoryProtocol
    
    init(repository: RSSFeedRepositoryProtocol = RSSFeedRepository.shared) {
        self.repository = repository
    }

    func execute(feedURL: URL) async throws -> RSSFeed {
        return try await repository.getFeedDetails(feedURL: feedURL)
    }
}

final class MockGetRSSFeedDetailsUseCase: GetRSSFeedDetailsUseCaseProtocol {
    var result: RSSFeed = .mock
    func execute(feedURL: URL) async throws -> RSSFeed {
        return result
    }
}

