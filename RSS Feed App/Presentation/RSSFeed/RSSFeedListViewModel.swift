//
//  RSSFeedListViewModel.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import SwiftUI

@Observable
final class RSSFeedListViewModel: ObservableObject {
    private var feeds: [RSSListItem] = []
    var newFeedURL: String = ""
    var isShowingFavorites: Bool = false
    
    var loading: Bool = false
    var alertItem: AlertItem?
    
    var filteredFeeds: [RSSListItem] {
        isShowingFavorites ? feeds.filter(\.isFavorite) : feeds
    }
    
    var isAddingDisabled: Bool {
        withAnimation(.smooth) {
            newFeedURL.isEmpty
        }
    }
    
    var hasFeeds: Bool {
        withAnimation(.smooth) {
            !feeds.isEmpty
        }
    }
    
    private let addRSSFeedUseCase: AddRSSFeedUseCaseProtocol = AddRSSFeedUseCase()
    private let removeRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol = RemoveRSSFeedUseCase()
    private let getRSSFeedsUseCase: GetRSSFeedListUseCaseProtocol = GetRSSFeedListUseCase()
    private let getRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol = GetRSSFeedItemsUseCase()
    private let toggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol = ToggleFavoriteFeedUseCase()
    
    func loadFeeds() async {
        guard feeds.isEmpty else { return }
        
        loading = true
        feeds = getRSSFeedsUseCase.execute()
        loading = false
    }
    
    func addFeed() async {
        guard newFeedURL != "",
              let url = URL(string: newFeedURL) else {
            loading = false
            newFeedURL = ""
            return
        }
        
        loading = true
        defer {
            loading = false
            withAnimation(.default) {
                newFeedURL = ""
            }
        }
        
        do {
            let result = try await addRSSFeedUseCase.execute(url: url)
            feeds.insert(.init(from: result), at: 0)
        } catch {
            alertItem = AlertItem(message: error.localizedDescription)
        }
    }
    
    func removeFeed(with url: URL) {
        removeRSSFeedUseCase.execute(feedURL: url)
        
        withAnimation(.default) {
            feeds.removeAll { $0.url == url }
        }
    }
    
    func toggleFavorite(with url: URL) {
        guard let index = feeds.firstIndex(where: { $0.url == url }) else { return }
        
        Task {
            await toggleFavoriteFeedUseCase.execute(feedURL: url)
        }
        
        withAnimation(.default) {
            feeds[index].isFavorite.toggle()
        }
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
}
