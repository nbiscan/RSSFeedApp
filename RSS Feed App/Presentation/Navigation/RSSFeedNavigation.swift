//
//  RSSFeedNavigation.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 07.11.2024..
//

import SwiftUI

struct RSSFeedNavigation<Content: View>: View {
    @State private var path: NavigationPath = .init()
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            content
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case let .rssFeedDetails(viewModel):
                        RSSFeedDetailsView(rssFeedDetailsViewModel: viewModel)
                    case let .webView(url):
                        WebView(url: url)
                    }
                }
        }
    }
}
