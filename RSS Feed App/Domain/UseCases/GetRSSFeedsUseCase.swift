//
//  GetRSSFeedsUseCase.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol GetRSSFeedsUseCaseProtocol {
    func execute() async -> [RSSFeed]
}

extension GetRSSFeedsUseCaseProtocol {
    func callAsFunction() async -> [RSSFeed] {
        await execute()
    }
}

final class GetRSSFeedsUseCase: GetRSSFeedsUseCaseProtocol {
    let repository = RSSFeedRepository.shared

    func execute() async -> [RSSFeed] {
        return await repository.getFeeds()
    }
}

final class MockGetRSSFeedsUseCase: GetRSSFeedsUseCaseProtocol {
    var result: [RSSFeed] = [.mock]
    func execute() async -> [RSSFeed] {
        return result
    }
}
