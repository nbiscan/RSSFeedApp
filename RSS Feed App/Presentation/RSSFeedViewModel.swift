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
    var alertItem: AlertItem?
    
    private let addRSSFeedUseCase: AddRSSFeedUseCaseProtocol = AddRSSFeedUseCase()
    private let removeRSSFeedUseCase: RemoveRSSFeedUseCaseProtocol = RemoveRSSFeedUseCase()
    private let getRSSFeedsUseCase: GetRSSFeedsUseCaseProtocol = GetRSSFeedsUseCase()
    private let getRSSFeedItemsUseCase: GetRSSFeedItemsUseCaseProtocol = GetRSSFeedItemsUseCase()
    
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
            withAnimation {
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
        print("Attempting to remove feed with URL: \(url)")
        removeRSSFeedUseCase.execute(feedURL: url)
        
        feeds.removeAll { $0.url == url }
    }

}

struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
}
