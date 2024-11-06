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

final class RemoveRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol {
    let repository = RSSFeedRepository.shared
    
    func execute(feedURL: URL) {
        repository.removeFeed(url: feedURL)
    }
}

final class MockRemoveRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol {
    func execute(feedURL: URL) { }
}
