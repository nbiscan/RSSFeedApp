//
//  RSSFeedItemsListView.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 15.10.2024..
//

import SwiftUI

struct RSSFeedItemsListView: View {
    let feed: RSSFeed // Accept the selected feed as a parameter

       var body: some View {
           VStack {
               Text(feed.title)
                   .font(.largeTitle)
                   .padding()
               Text(feed.description)
                   .font(.body)
                   .padding()
               // Additional UI components to show more details, such as RSS items
               Spacer()
           }
           .navigationTitle("Feed Details") // Set the navigation title
           .navigationBarTitleDisplayMode(.inline) // Display title inline
       }
}

#Preview {
    RSSFeedItemsListView(feed: .mock)
}
