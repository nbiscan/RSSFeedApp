//
//  RemoveRSSFeedUseCase.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol RemoveRSSFeedUseCaseProtocol {
    func execute(feedURL: URL)
}

extension RemoveRSSFeedUseCaseProtocol {
    func callAsFunction(feedURL: URL) {
        execute(feedURL: feedURL)
    }
}

final class RemoveRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol {
    private let repository: RSSFeedRepositoryProtocol
    
    init(repository: RSSFeedRepositoryProtocol = RSSFeedRepository.shared) {
        self.repository = repository
    }
    
    func execute(feedURL: URL) {
        repository.removeFeed(url: feedURL)
    }
}

final class MockRemoveRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol {
    func execute(feedURL: URL) { }
}
