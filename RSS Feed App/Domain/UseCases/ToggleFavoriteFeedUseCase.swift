//
//  ToggleFavoriteFeedUseCase.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol ToggleFavoriteFeedUseCaseProtocol {
    func execute(feedURL: URL) async
}

extension ToggleFavoriteFeedUseCaseProtocol {
    func callAsFunction(feedURL: URL) async {
        await execute(feedURL: feedURL)
    }
}

final class ToggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol {
    private let repository: RSSFeedRepositoryProtocol
    
    init(repository: RSSFeedRepositoryProtocol = RSSFeedRepository.shared) {
        self.repository = repository
    }

    func execute(feedURL: URL) async {
        await repository.toggleFavoriteFeed(feedURL: feedURL)
    }
}

final class MockToggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol {
    func execute(feedURL: URL) async { }
}
