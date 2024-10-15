//
//  RSSFeedViewModel.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import SwiftUI

@Observable
final class RSSFeedListViewModel: ObservableObject {
    var feeds: [RSSFeed] = []
    var newFeedURL: String = ""
    
    private let addRSSFeedUseCase: AddRSSFeedUseCaseProtocol = AddRSSFeedUseCase()
    private let removeRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol = RemoveRSSFeedUseCase()
    private let getRSSFeedsUseCase: GetRSSFeedsUseCaseProtocol = GetRSSFeedsUseCase()
    private let getRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol = GetRSSFeedItemsUseCase()
    private let toggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol = ToggleFavoriteFeedUseCase()
    private let enableNotificationsUseCase: EnableNotificationsUseCaseProtocol = EnableNotificationsUseCase()
    
    func loadFeeds() {
        feeds = getRSSFeedsUseCase.execute()
    }
    
    func addFeed() {
        guard newFeedURL != "" else { return }
        guard let url = URL(string: newFeedURL) else {
            newFeedURL = ""
            return
        }
        
        let result = addRSSFeedUseCase.execute(url: url)
        
        feeds.append(result)
        withAnimation {
            newFeedURL = ""
        }
    }
    
    func removeFeed(with id: UUID) {
        removeRSSFeedUseCase.execute(feedId: id)
        
        feeds.removeAll { $0.id == id }
    }
    
    func toggleFavoriteFeed(with id: UUID) {
        toggleFavoriteFeedUseCase.execute(feedId: id)
        
        if let index = feeds.firstIndex(where: { $0.id == id }) {
            feeds[index].isFavorite.toggle()
        }
    }
}
