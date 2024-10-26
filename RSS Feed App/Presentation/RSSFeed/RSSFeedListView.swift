//
//  RSSFeedListView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 15.10.2024..
//

import SwiftUI

struct RSSFeedListView: View {
    @State private var viewModel: RSSFeedListViewModel = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                header
                
                List {
                    ForEach(viewModel.filteredFeeds, id: \.id) { feed in
                        NavigationLink(destination: RSSFeedDetailsView(feedURL: feed.url)) {
                            RSSFeedCard(feed: feed)
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        viewModel.toggleFavorite(with: feed.url)
                                    } label: {
                                        Label(feed.isFavorite ? "Unfavorite" : "Favorite",
                                              systemImage: feed.isFavorite ? "star.fill" : "star")
                                    }
                                    .tint(feed.isFavorite ? .yellow : .blue)
                                }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let feed = viewModel.filteredFeeds[index]
                            viewModel.removeFeed(with: feed.url)
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .isLoading(viewModel.loading)
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: Text("Error"),
                    message: Text(alertItem.message),
                    dismissButton: .default(Text("OK")) {
                        viewModel.alertItem = nil
                    }
                )
            }
            .task {
                await viewModel.loadFeeds()
            }
            .navigationTitle("RSS Feeds")
        }
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                TextField("Enter RSS Feed URL", text: $viewModel.newFeedURL)
                    .keyboardType(.URL)
                
                Button(action: {
                    Task {
                        await viewModel.addFeed()
                    }
                }) {
                    Text("Add")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
            Button(viewModel.isShowingFavorites ? "Show All" : "Show Favorites") {
                withAnimation(.default) {
                    viewModel.isShowingFavorites.toggle()
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(.horizontal)
    }
}
#Preview {
    RSSFeedListView()
}
