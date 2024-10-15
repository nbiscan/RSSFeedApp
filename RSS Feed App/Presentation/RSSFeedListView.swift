//
//  RSSFeedListView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 15.10.2024..
//

import SwiftUI

struct RSSFeedListView: View {
    @StateObject private var viewModel: RSSFeedListViewModel = .init()
    
    @ViewBuilder
    private func feedView(feed: RSSFeed) -> some View {
        HStack {
            Text(feed.url.absoluteString)
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    viewModel.toggleFavoriteFeed(with: feed.id)
                }
            }) {
                Image(systemName: feed.isFavorite ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.gray)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter RSS Feed URL", text: $viewModel.newFeedURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            viewModel.addFeed()
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
                .padding(.horizontal)
                
                List {
                    ForEach(viewModel.feeds) { feed in
                        NavigationLink(destination: RSSFeedItemsListView(feed: feed)) {
                            feedView(feed: feed)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let feed = viewModel.feeds[index]
                            viewModel.removeFeed(with: feed.id)
                        }
                    }
                }
            }
            .onAppear {
                withAnimation(.spring()) {
                    viewModel.loadFeeds()
                }
            }
            .navigationTitle("RSS Feeds")
        }
    }
}
#Preview {
    RSSFeedListView()
}
