//
//  RSSFeedListView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 15.10.2024..
//

import SwiftUI

struct RSSFeedListView: View {
    @StateObject private var viewModel: RSSFeedListViewModel = .init()
        
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter RSS Feed URL", text: $viewModel.newFeedURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
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
                .padding(.horizontal)
                
                List {
                    ForEach(viewModel.feeds) { feed in
                        NavigationLink(destination: RSSFeedDetailsView(feed: feed)) {
                            RSSFeedCard(feed: feed)
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
            .isLoading(viewModel.loading)
            .task {
                await viewModel.loadFeeds()
            }
            .navigationTitle("RSS Feeds")
        }
    }
}
#Preview {
    RSSFeedListView()
}
