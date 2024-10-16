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
    
    var loading: Bool = false
    var alertText: String?
    
    private let addRSSFeedUseCase: AddRSSFeedUseCaseProtocol = AddRSSFeedUseCase()
    private let removeRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol = RemoveRSSFeedUseCase()
    private let getRSSFeedsUseCase: GetRSSFeedsUseCaseProtocol = GetRSSFeedsUseCase()
    private let getRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol = GetRSSFeedItemsUseCase()
    private let toggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol = ToggleFavoriteFeedUseCase()
    private let enableNotificationsUseCase: EnableNotificationsUseCaseProtocol = EnableNotificationsUseCase()
    
    func loadFeeds() {
        loading = true
        feeds = getRSSFeedsUseCase.execute()
        loading = false
    }
    
    func addFeed() async {
        guard newFeedURL != "", let url = URL(string: newFeedURL) else {
            loading = false
            newFeedURL = ""
            return
        }
        
        loading = true
        defer {
            loading = false
            withAnimation {
                newFeedURL = ""
            }
        }
        
        do {
            let result = try await addRSSFeedUseCase.execute(url: url)
            feeds.append(result)
        } catch {
            alertText = error.localizedDescription
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
