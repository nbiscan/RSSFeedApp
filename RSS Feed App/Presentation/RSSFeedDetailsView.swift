//
//  RSSFeedItemsListView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 15.10.2024..
//
import SwiftUI

struct RSSFeedDetailsView: View {
    @StateObject private var viewModel: RSSFeedDetailsViewModel
    @State private var showMore: Bool = false
    @State private var isExpandable: Bool = false
    
    init(feed: RSSFeed) {
        _viewModel = StateObject(wrappedValue: RSSFeedDetailsViewModel(feed: feed))
    }
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    HStack {
                        if let url = viewModel.feed.imageUrl {
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
                        
                        Text(viewModel.feed.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    ZStack {
                        Text(viewModel.feed.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
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
                ForEach(viewModel.feed.items, id: \.id) { item in
                    itemCell(for: item)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func itemCell(for item: RSSItem) -> some View {
        NavigationLink(destination: WebView(url: item.link)) {
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
    RSSFeedDetailsView(feed: .mock)
}
