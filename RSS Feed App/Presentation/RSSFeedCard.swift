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
        VStack {
            Text(feed.title)
                .font(.headline)
            
            Text(feed.description)
            
            Text(feed.url.absoluteString)
                .font(.footnote)
            
            if let url = feed.imageUrl {
                AsyncImage(url: url)
                    .frame(width: 100, height: 100)
            }
            
            HStack {
                Image(systemName: feed.isFavorite ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
    }
}

#Preview {
    RSSFeedCard(feed: .mock)
}
