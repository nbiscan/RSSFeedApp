//
//  AddRSSFeedUseCase.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol AddRSSFeedUseCaseProtocol {
    func execute(url: URL) async throws -> RSSFeed
}

final class AddRSSFeedUseCase: AddRSSFeedUseCaseProtocol {
    let repository = RSSFeedRepository.shared
    
    func execute(url: URL) async throws -> RSSFeed {
        return try await repository.addFeed(url: url)
    }
}

final class MockAddRSSFeedUseCase: AddRSSFeedUseCaseProtocol {
    var result: RSSFeed = .mock
    func execute(url: URL) async throws -> RSSFeed {
        return result
    }
}
