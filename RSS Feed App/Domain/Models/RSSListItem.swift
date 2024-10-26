//
//  RSSListItem.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 26.10.2024..
//

import Foundation

struct RSSListItem: Identifiable, Equatable {
    let url: URL
    let title: String
    let description: String
    let imageUrl: URL?
    var isFavorite: Bool
    
    var id: URL { url }
    
    init(url: URL, title: String, description: String, imageUrl: URL?, isFavorite: Bool) {
        self.url = url
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.isFavorite = isFavorite
    }

    init(from feed: RSSFeed) {
        self.url = feed.url
        self.title = feed.title
        self.description = feed.description
        self.imageUrl = feed.imageUrl
        self.isFavorite = feed.isFavorite
    }
}

extension RSSListItem {
    static var mock: Self { .init(from: .mock) }
}
