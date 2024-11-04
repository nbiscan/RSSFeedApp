//
//  RSSFeedListViewModel.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import SwiftUI

@Observable
final class RSSFeedListViewModel: ObservableObject {
    var feeds: [RSSListItem] = []
    var newFeedURL: String = ""
    var isShowingFavorites: Bool = false
    var searchText: String = ""
    
    var loading: Bool = true
    var alertItem: AlertItem?
    
    var filteredFeeds: [RSSListItem] {
        let filteredItems = isShowingFavorites ? feeds.filter(\.isFavorite) : feeds
        
        if searchText.isEmpty {
            return filteredItems
        } else {
            return filteredItems.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var isAddingDisabled: Bool {
        withAnimation(.smooth) {
            newFeedURL.isEmpty
        }
    }
    
    var shouldShowEmptyState: Bool {
        filteredFeeds.isEmpty && !loading
    }
    
    var hasFeeds: Bool {
        withAnimation(.smooth) {
            !feeds.isEmpty
        }
    }
    
    private let addRSSFeedUseCase: AddRSSFeedUseCaseProtocol
    private let removeRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol
    private let getRSSFeedsUseCase: GetRSSFeedListUseCaseProtocol
    private let getRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol
    private let toggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol
    
    init(addRSSFeedUseCase: AddRSSFeedUseCaseProtocol = AddRSSFeedUseCase(),
         removeRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol = RemoveRSSFeedUseCase(),
         getRSSFeedsUseCase: GetRSSFeedListUseCaseProtocol = GetRSSFeedListUseCase(),
         getRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol = GetRSSFeedItemsUseCase(),
         toggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol = ToggleFavoriteFeedUseCase()) {
        self.addRSSFeedUseCase = addRSSFeedUseCase
        self.removeRSSFeedUseCase = removeRSSFeedUseCase
        self.getRSSFeedsUseCase = getRSSFeedsUseCase
        self.getRSSFeedItemsUseCase = getRSSFeedItemsUseCase
        self.toggleFavoriteFeedUseCase = toggleFavoriteFeedUseCase
    }
    
    func loadFeeds() async {
        guard feeds.isEmpty else { return }
        
        loading = true
        defer {
            loading = false
        }
        
        feeds = getRSSFeedsUseCase.execute()
       
    }
    
    func addFeed() async {
        let trimmedNewUrl = newFeedURL.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard newFeedURL != "",
              let url = URL(string: trimmedNewUrl) else {
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
            isShowingFavorites = false
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
    
    func toggleFavorite(with url: URL) async {
        guard let index = feeds.firstIndex(where: { $0.url == url }) else { return }
        
        await toggleFavoriteFeedUseCase.execute(feedURL: url)
        
        withAnimation(.default) {
            feeds[index].isFavorite.toggle()
        }
    }
}
