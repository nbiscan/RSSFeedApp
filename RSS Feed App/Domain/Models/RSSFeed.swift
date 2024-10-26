//
//  RSSFeed.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

struct RSSFeed: Identifiable, Codable {
    let title: String
    let description: String
    let imageUrl: URL?
    let url: URL
    var isFavorite: Bool
    var notificationsEnabled: Bool
    var items: [RSSItem]
    
    var id: URL { url }
}

extension RSSFeed {
    static var mock: Self {
        .init(
            title: "Mock Title",
            description: "Mock Description",
            imageUrl: nil,
            url: .init(string: "https://example.com")!,
            isFavorite: false,
            notificationsEnabled: false,
            items: [.mock])
    }
}
