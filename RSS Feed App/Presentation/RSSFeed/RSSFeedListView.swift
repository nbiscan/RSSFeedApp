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
                
                if viewModel.hasFeeds {
                    list
                } else {
                    Spacer()
                    
                    emptyState
                    
                    Spacer()
                }
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
            .navigationTitle("Your RSS Feeds")
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
                        .background(viewModel.isAddingDisabled ? Color.gray : Color.blue)
                        .opacity(viewModel.isAddingDisabled ? 0.3 : 1)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.isAddingDisabled)
            }
            
            if viewModel.hasFeeds {
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
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var list: some View {
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
    
    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("Tune into the latest stories!")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("It’s a bit quiet here... Start exploring by adding your favorite feeds!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
        }
        .padding()
    }
}

#Preview {
    RSSFeedListView()
}
