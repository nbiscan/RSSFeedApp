//
//  FeedItemView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 16.10.2024..
//

import SwiftUI
struct RSSFeedCard: View {
    let feed: RSSFeed
    
    var body: some View {
        HStack(spacing: 16) {
            if let imageUrl = feed.imageUrl {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .shadow(radius: 1)
                        .cornerRadius(8)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(width: 70, height: 70)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(feed.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(feed.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
        }
        .padding()
        .cornerRadius(12)
    }
}

#Preview {
    RSSFeedCard(feed: .mock)
}
