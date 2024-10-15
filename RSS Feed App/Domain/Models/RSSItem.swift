//
//  RSSItem.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

struct RSSItem: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let imageUrl: URL?
    let link: URL
}

extension RSSItem {
    static var mock: Self {
        .init(
            id: .init(),
            title: "Title",
            description: "Description",
            imageUrl: nil,
            link: URL(string: "https://example.com")!
        )
    }
}
