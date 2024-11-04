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
    
    override func setUp() {
        super.setUp()
        
        mockGetDetailsUseCase = MockGetRSSFeedDetailsUseCase()
        mockToggleNotificationsUseCase = MockToggleNotificationsUseCase()
        
        viewModel = RSSFeedDetailsViewModel(feedURL: feedURL,
                                            getRSSFeedDetailsUseCase: mockGetDetailsUseCase,
                                            toggleNotificationsUseCase: mockToggleNotificationsUseCase)
    }
    
    override func tearDown() {
        viewModel = nil
        mockGetDetailsUseCase = nil
        mockToggleNotificationsUseCase = nil
        super.tearDown()
    }
    
    func testLoadFeedDetails_SetsFeedAndNotificationsEnabled() async {
        let expectedFeed = RSSFeed.mock
        mockGetDetailsUseCase.result = expectedFeed
        
        await viewModel.loadFeedDetails()
        
        XCTAssertEqual(viewModel.feed, expectedFeed)
        XCTAssertEqual(viewModel.notificationsEnabled, expectedFeed.notificationsEnabled)
    }

    func testLoadFeedDetails_SetsLoadingStateCorrectly() async {
        mockGetDetailsUseCase.result = RSSFeed.mock
        
        await viewModel.loadFeedDetails()
        
        XCTAssertFalse(viewModel.loading)
    }
    
    func testToggleNotifications_EnablesNotifications() async {
        let expectedFeed = RSSFeed.mock
        mockGetDetailsUseCase.result = expectedFeed
        await viewModel.loadFeedDetails()
        
        viewModel.notificationsEnabled = true
        
        XCTAssertEqual(mockToggleNotificationsUseCase.receivedFeedURL, expectedFeed.url)
        XCTAssertEqual(mockToggleNotificationsUseCase.receivedIsEnabled, true)
    }
    
    func testToggleNotifications_DisablesNotifications() async {
        let expectedFeed = RSSFeed.mock
        mockGetDetailsUseCase.result = expectedFeed
        await viewModel.loadFeedDetails()
        
        viewModel.notificationsEnabled = false
        
        XCTAssertEqual(mockToggleNotificationsUseCase.receivedFeedURL, expectedFeed.url)
        XCTAssertEqual(mockToggleNotificationsUseCase.receivedIsEnabled, false)
    }
}
