//
//  RSSFeedRepositoryTests.swift
//  RSS Feed AppTests
//
//  Created by Natko Biscan on 04.11.2024..
//

import XCTest
@testable import RSS_Feed_App

class RSSFeedRepositoryTests: XCTestCase {
    var repository: RSSFeedRepository!
    var mockService: MockRSSFeedService!
    var mockDataSource: MockLocalStorageDataSource<RSSFeed>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockService = MockRSSFeedService()
        mockDataSource = MockLocalStorageDataSource<RSSFeed>(storageKey: "test")
        repository = RSSFeedRepository(service: mockService, dataSource: mockDataSource)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        repository = nil
        mockService = nil
        mockDataSource = nil
    }
    
    func testAddFeed() async throws {
        let url = URL(string: Constants.testingRSSURL)!
        let expectedFeed = RSSFeed.mock
        mockService.feedToReturn = expectedFeed
        
        let addedFeed = try await repository.addFeed(url: url)
        
        XCTAssertEqual(addedFeed, expectedFeed)
        XCTAssertEqual(mockDataSource.storedEntities.count, 1)
        XCTAssertEqual(mockDataSource.storedEntities.first?.url, url)
        XCTAssertEqual(mockDataSource.storedEntities.first?.isFavorite, false)
    }
    
    func testRemoveFeed() {
        let url = URL(string: Constants.testingRSSURL)!
        mockDataSource.storedEntities = [RSSFeed.mock]
        
        repository.removeFeed(url: url)
        
        XCTAssertTrue(mockDataSource.storedEntities.isEmpty)
    }
    
    func testGetFeeds() async {
        let expectedFeeds = [RSSFeed.mock]
        mockDataSource.storedEntities = expectedFeeds
        
        let feeds = await repository.getFeeds()
        
        XCTAssertEqual(feeds, expectedFeeds)
    }
    
    func testGetFeedDetailsUpdatesStoredFeed() async throws {
        let url = URL(string: Constants.testingRSSURL)!
        let updatedFeed = RSSFeed.mock
        mockService.feedToReturn = updatedFeed
        mockDataSource.storedEntities = [RSSFeed.mock]
        
        let fetchedFeed = try await repository.getFeedDetails(feedURL: url)
        
        XCTAssertEqual(fetchedFeed, updatedFeed)
        XCTAssertEqual(mockDataSource.storedEntities.first, updatedFeed)
    }
    
    func testToggleFavoriteFeed() async {
        let url = URL(string: Constants.testingRSSURL)!
        var feed = RSSFeed.mock
        feed.isFavorite = false
        mockDataSource.storedEntities = [feed]
        
        await repository.toggleFavoriteFeed(feedURL: url)
        
        if let updatedFeed = mockDataSource.storedEntities.first {
            XCTAssertTrue(updatedFeed.isFavorite)
        } else {
            XCTFail("Expected feed not found in stored entities.")
        }
    }
    
    func testToggleNotificationsToTrue() async throws {
        let url = URL(string: Constants.testingRSSURL)!
        var feed = RSSFeed.mock
        feed.notificationsEnabled = false
        mockDataSource.storedEntities = [feed]
        
        await repository.toggleNotifications(feedURL: url, enable: true)
        
        if let updatedFeed = mockDataSource.storedEntities.first {
            XCTAssertTrue(updatedFeed.notificationsEnabled)
        } else {
            XCTFail("Expected feed not found in stored entities.")
        }
    }
    
    func testToggleNotificationsToFalse() async throws {
        let url = URL(string: Constants.testingRSSURL)!
        var feed = RSSFeed.mock
        feed.notificationsEnabled = false
        mockDataSource.storedEntities = [feed]
        
        await repository.toggleNotifications(feedURL: url, enable: false)
        
        if let updatedFeed = mockDataSource.storedEntities.first {
            XCTAssertFalse(updatedFeed.notificationsEnabled)
        } else {
            XCTFail("Expected feed not found in stored entities.")
        }
    }
}
