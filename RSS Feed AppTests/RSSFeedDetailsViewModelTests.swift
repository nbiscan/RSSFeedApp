//
//  RSSFeedDetailsViewModelTests.swift
//  RSS Feed AppTests
//
//  Created by Natko Biscan on 26.10.2024..
//

import XCTest
@testable import RSS_Feed_App

final class RSSFeedDetailsViewModelTests: XCTestCase {
    private var viewModel: RSSFeedDetailsViewModel!
    private var mockGetDetailsUseCase: MockGetRSSFeedDetailsUseCase!
    private var mockToggleNotificationsUseCase: MockToggleNotificationsUseCase!
    private let feedURL = URL(string: "https://example.com/rss")!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockGetDetailsUseCase = MockGetRSSFeedDetailsUseCase()
        mockToggleNotificationsUseCase = MockToggleNotificationsUseCase()
        
        viewModel = RSSFeedDetailsViewModel(feedURL: feedURL,
                                            getRSSFeedDetailsUseCase: mockGetDetailsUseCase,
                                            toggleNotificationsUseCase: mockToggleNotificationsUseCase)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()

        viewModel = nil
        mockGetDetailsUseCase = nil
        mockToggleNotificationsUseCase = nil
    }
    
    func testLoadFeedDetails_SetsFeedAndNotificationsEnabled() async throws {
        let expectedFeed = RSSFeed.mock
        mockGetDetailsUseCase.result = expectedFeed
        
        await viewModel.loadFeedDetails()
        
        XCTAssertEqual(viewModel.feed, expectedFeed)
        XCTAssertEqual(viewModel.notificationsEnabled, expectedFeed.notificationsEnabled)
    }

    func testLoadFeedDetails_SetsLoadingStateCorrectly() async throws {
        mockGetDetailsUseCase.result = RSSFeed.mock
        
        await viewModel.loadFeedDetails()
        
        XCTAssertFalse(viewModel.loading)
    }
}
