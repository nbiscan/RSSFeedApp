//
//  GetRSSFeedListUseCase.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol GetRSSFeedListUseCaseProtocol {
    func execute() -> [RSSListItem]
}

extension GetRSSFeedListUseCaseProtocol {
    func callAsFunction() -> [RSSListItem] {
        execute()
    }
}

final class GetRSSFeedListUseCase: GetRSSFeedListUseCaseProtocol {
    private let repository: RSSFeedRepositoryProtocol
    
    init(repository: RSSFeedRepositoryProtocol = RSSFeedRepository.shared) {
        self.repository = repository
    }

    func execute() -> [RSSListItem] {
        return repository.getLocalFeeds().map { .init(from: $0) }
    }
}

final class MockGetRSSFeedListUseCase: GetRSSFeedListUseCaseProtocol {
    var result: [RSSListItem] = [.mock]
    func execute() -> [RSSListItem] {
        return result
    }
}
