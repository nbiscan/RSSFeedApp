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
        VStack(alignment: .leading) {
            Text(feed.title)
                .font(.headline)
            
            Text(feed.description)
            
            if let url = feed.imageUrl {
                AsyncImage(url: url)
                    .frame(width: 100, height: 100)
            }
        }
        .padding()
    }
}

#Preview {
    RSSFeedCard(feed: .mock)
}
