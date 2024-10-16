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
           VStack {
               Text(feed.title)
                   .font(.largeTitle)
                   .padding()
               
               Text(feed.description)
                   .font(.body)
                   .padding()
               
               Text(feed.url.absoluteString)
               
               if let url = feed.imageUrl {
                   AsyncImage(url: url)
                       .frame(width: 100, height: 100)
               }
               
               Divider()
               
               List(feed.items) { item in
                   VStack(alignment: .leading) {

                       Text(item.title)
                           .font(.headline)
                       
                       Text(item.description)
                           .font(.subheadline)
                           .foregroundColor(.secondary)
                           .lineLimit(2)
                       
                       if let imageUrl = item.imageUrl {
                           AsyncImage(url: imageUrl)
                               .frame(width: 60, height: 60)
                               .cornerRadius(8)
                       }
                   }
                   .padding(.vertical, 8)
               }
           }
           .navigationTitle(feed.title)
           .navigationBarTitleDisplayMode(.inline)
       }
}

#Preview {
    RSSFeedDetailsView(feed: .mock)
}
