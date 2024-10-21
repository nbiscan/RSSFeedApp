//
//  RSSFeedViewModel.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import SwiftUI

@Observable
final class RSSFeedListViewModel: ObservableObject {
    private var feeds: [RSSFeed] = []
    var newFeedURL: String = ""
    var isShowingFavorites: Bool = false
    
    var loading: Bool = false
    var alertItem: AlertItem?
    
    var filteredFeeds: [RSSFeed] {
        isShowingFavorites ? feeds.filter(\.isFavorite) : feeds
    }
    
    private let addRSSFeedUseCase: AddRSSFeedUseCaseProtocol = AddRSSFeedUseCase()
    private let removeRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol = RemoveRSSFeedUseCase()
    private let getRSSFeedsUseCase: GetRSSFeedsUseCaseProtocol = GetRSSFeedsUseCase()
    private let getRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol = GetRSSFeedItemsUseCase()
    private let toggleFavoriteFeedUseCase: ToggleFavoriteFeedUseCaseProtocol = ToggleFavoriteFeedUseCase()
    
    func loadFeeds() async {
        print(UserDefaults.standard.dictionaryRepresentation())
        
        loading = true
        feeds = await getRSSFeedsUseCase.execute()
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
            withAnimation(.smooth) {
                newFeedURL = ""
            }
        }
        
        do {
            let result = try await addRSSFeedUseCase.execute(url: url)
            feeds.append(result)
        } catch {
            alertItem = AlertItem(message: error.localizedDescription)
        }
    }
    
    func removeFeed(with url: URL) {
        removeRSSFeedUseCase.execute(feedURL: url)
        feeds.removeAll { $0.url == url }
    }
    
    func toggleFavorite(with url: URL) {
        guard let index = feeds.firstIndex(where: { $0.url == url }) else { return }
        let feed = feeds[index]
        
        Task {
            do {
                await toggleFavoriteFeedUseCase.execute(feedURL: url)
                feeds[index].isFavorite.toggle()
            } catch {
                alertItem = AlertItem(message: error.localizedDescription)
            }
        }
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
}
