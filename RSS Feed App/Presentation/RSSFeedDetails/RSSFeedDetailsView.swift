//
//  RSSFeedItemsListView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 15.10.2024..
//
import SwiftUI

struct RSSFeedDetailsView: View {
    @State private var viewModel: RSSFeedDetailsViewModel
    @State private var showMore: Bool = false
    @State private var isExpandable: Bool = false
    
    init(rssFeedDetailsViewModel: RSSFeedDetailsViewModel) {
        viewModel = rssFeedDetailsViewModel
    }
    
    var body: some View {
        List {
            if let feed = viewModel.feed {
                Section {
                    VStack(spacing: 16) {
                        HStack {
                            if let url = feed.imageUrl {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(12)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            
                            Text(feed.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal)
                        }
                        
                        ZStack {
                            Text(feed.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(showMore ? nil : 4)
                                .background(
                                    GeometryReader { geo in
                                        Color.clear.onAppear {
                                            let fourLineHeight: CGFloat = 72
                                            if geo.size.height > fourLineHeight {
                                                isExpandable = true
                                            }
                                        }
                                    }
                                )
                                .padding(.horizontal)
                        }
                        
                        if isExpandable {
                            Button(action: {
                                withAnimation {
                                    showMore.toggle()
                                }
                            }) {
                                Text(showMore ? "Show Less" : "Show More")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Toggle("Enable Notifications", isOn: $viewModel.notificationsEnabled)
                        .padding(.horizontal)
                }
                
                Section {
                    ForEach(feed.items, id: \.id) { item in
                        itemCell(for: item)
                    }
                }
            }
        }
        .isLoading(viewModel.loading)
        .onAppear {
            Task {
                await viewModel.loadFeedDetails()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func itemCell(for item: RSSItem) -> some View {
        NavigationLink(value: NavigationDestination.webView(item.link)) {
            HStack(spacing: 12) {
                if let imageUrl = item.imageUrl {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    RSSFeedDetailsView(rssFeedDetailsViewModel: .init(feedURL: URL(string: Constants.URLs.testingRSSURL)!))
}
