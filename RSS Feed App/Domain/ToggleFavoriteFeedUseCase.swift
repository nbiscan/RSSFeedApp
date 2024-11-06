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

final class ToggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol {
    let repository = RSSFeedRepository.shared

    func execute(feedURL: URL) async {
        await repository.toggleFavoriteFeed(feedURL: feedURL)
    }
}

final class MockToggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol {
    func execute(feedURL: URL) async { }
}
