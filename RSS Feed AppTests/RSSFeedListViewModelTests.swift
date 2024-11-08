//
//  RSSFeedListViewModelTests.swift
//  RSS Feed AppTests
//
//  Created by Natko Biscan on 26.10.2024..
//

import XCTest
@testable import RSS_Feed_App

final class RSSFeedListViewModelTests: XCTestCase {
    private var viewModel: RSSFeedListViewModel!
    private var mockAddFeedUseCase: MockAddRSSFeedUseCase!
    private var mockRemoveFeedUseCase: MockRemoveRSSFeedUseCase!
    private var mockGetFeedsUseCase: MockGetRSSFeedListUseCase!
    private var mockToggleFavoriteUseCase: MockToggleFavoriteFeedUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockAddFeedUseCase = MockAddRSSFeedUseCase()
        mockRemoveFeedUseCase = MockRemoveRSSFeedUseCase()
        mockGetFeedsUseCase = MockGetRSSFeedListUseCase()
        mockToggleFavoriteUseCase = MockToggleFavoriteFeedUseCase()
        
        viewModel = RSSFeedListViewModel(
            addRSSFeedUseCase: mockAddFeedUseCase,
            removeRSSFeedUseCase: mockRemoveFeedUseCase,
            getRSSFeedListUseCase: mockGetFeedsUseCase,
            toggleFavoriteFeedUseCase: mockToggleFavoriteUseCase
        )
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()

        viewModel = nil
        mockAddFeedUseCase = nil
        mockRemoveFeedUseCase = nil
        mockGetFeedsUseCase = nil
        mockToggleFavoriteUseCase = nil
    }
    
    func testLoadFeedsLoadsFeedsFromUseCase() async throws {
        let mockFeeds = [RSSListItem.mock, RSSListItem.mock]
        mockGetFeedsUseCase.result = mockFeeds
        
        await viewModel.loadFeeds()
        
        XCTAssertFalse(viewModel.filteredFeeds.isEmpty)
        XCTAssertEqual(viewModel.filteredFeeds.count, mockFeeds.count)
    }
    
    func testAddFeedInsertsFeedAtTop() async throws {
        let newFeedURL = Constants.URLs.testingRSSURL
        let newFeed = RSSFeed.mock
        viewModel.newFeedURL = newFeedURL
        mockAddFeedUseCase.result = newFeed
        
        await viewModel.addFeed()
        
        XCTAssertEqual(viewModel.filteredFeeds.first?.url, newFeed.url)
    }
    
    func testRemoveFeedRemovesFeedFromList() async throws {
        let feedToRemove = RSSListItem.mock
        viewModel.feeds = [feedToRemove]
        
        viewModel.removeFeed(with: feedToRemove.url)
        
        XCTAssertFalse(viewModel.filteredFeeds.contains(where: { $0.url == feedToRemove.url }))
    }
    
    func testToggleFavoriteTogglesFavoriteStatus() async throws {
        let favoriteFeed = RSSListItem.mock
        viewModel.feeds = [favoriteFeed]
        
        await viewModel.toggleFavorite(with: favoriteFeed.url)
        
        XCTAssertEqual(viewModel.filteredFeeds.first?.isFavorite, !favoriteFeed.isFavorite)
    }
    
    func testFilteredFeedsReturnsOnlyFavoritesWhenFilterIsOn() throws {
        let favoriteFeed = RSSListItem(url: URL(string: "https://example.com")!, title: "Favorite Feed", description: "Description", imageUrl: nil, isFavorite: true)
        let nonFavoriteFeed = RSSListItem(url: URL(string: "https://example2.com")!, title: "Non-Favorite Feed", description: "Description", imageUrl: nil, isFavorite: false)
        viewModel.feeds = [favoriteFeed, nonFavoriteFeed]
        viewModel.isShowingFavorites = true
        
        let filteredFeeds = viewModel.filteredFeeds
        
        XCTAssertEqual(filteredFeeds, [favoriteFeed])
    }
    
//    func testFilteredFeedsReturnsMatchingSearchResults() throws {
//        let matchingFeed = RSSListItem(url: URL(string: "https://example.com")!, title: "Matching Feed", description: "Description", imageUrl: nil, isFavorite: false)
//        let nonMatchingFeed = RSSListItem(url: URL(string: "https://example2.com")!, title: "Non-Matching Feed", description: "Description", imageUrl: nil, isFavorite: false)
//        viewModel.feeds = [matchingFeed, nonMatchingFeed]
//        viewModel.searchText = "Matching"
//        
//        let filteredFeeds = viewModel.filteredFeeds
//        
//        XCTAssertEqual(filteredFeeds, [matchingFeed], "Expected only feeds matching the search text to be returned.")
//    }
}

