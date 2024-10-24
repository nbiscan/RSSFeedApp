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
            // Image block
            if let imageUrl = feed.imageUrl {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .cornerRadius(8)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(width: 70, height: 70)
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
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
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    RSSFeedCard(feed: .mock)
}
