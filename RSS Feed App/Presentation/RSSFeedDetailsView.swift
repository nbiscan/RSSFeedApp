//
//  RSSFeedItemsListView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 15.10.2024..
//

import SwiftUI
struct RSSFeedDetailsView: View {
    let feed: RSSFeed
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .center, spacing: 8) {
                Text(feed.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(feed.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            if let url = feed.imageUrl {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                        .frame(width: 120, height: 120)
                }
            }
            
            List(feed.items, id: \.id) { item in
                itemCell(for: item)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Make item a parameter for this function
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
