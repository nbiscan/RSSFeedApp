//
//  GetLocalRSSFeedsUseCase.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol GetLocalRSSFeedsUseCaseProtocol {
    func execute() -> [RSSFeed]
}

extension GetLocalRSSFeedsUseCaseProtocol {
    func callAsFunction() -> [RSSFeed] {
        execute()
    }
}

final class GetLocalRSSFeedsUseCase: GetLocalRSSFeedsUseCaseProtocol {
    private let repository: RSSFeedRepositoryProtocol
    
    init(repository: RSSFeedRepositoryProtocol = RSSFeedRepository.shared) {
        self.repository = repository
    }

    func execute() -> [RSSFeed] {
        return repository.getLocalFeeds()
    }
}

final class MockGetLocalRSSFeedsUseCase: GetLocalRSSFeedsUseCaseProtocol {
    var result: [RSSFeed] = [.mock]
    func execute() -> [RSSFeed] {
        return result
    }
}
