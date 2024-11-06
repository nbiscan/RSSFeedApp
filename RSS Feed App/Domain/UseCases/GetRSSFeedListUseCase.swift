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

final class GetRSSFeedListUseCase: GetRSSFeedListUseCaseProtocol {
    private let repository: RSSFeedRepositoryProtocol = RSSFeedRepository.shared

    func execute() -> [RSSListItem] {
        return repository.getFeedListItems()
    }
}

final class MockGetRSSFeedListUseCase: GetRSSFeedListUseCaseProtocol {
    var result: [RSSListItem] = [.mock]
    func execute() -> [RSSListItem] {
        return result
    }
}
