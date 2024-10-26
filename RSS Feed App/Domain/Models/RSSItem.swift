//
//  RSSItem.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

struct RSSItem: Identifiable, Codable {
    let title: String
    let description: String
    let imageUrl: URL?
    let link: URL
    
    init(title: String, description: String, imageUrl: URL?, link: URL) {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.link = link
    }
    
    var id: URL { link }
}

extension RSSItem {
    static var mock: Self {
        .init(title: "Title",
              description: "Description",
              imageUrl: nil,
              link: URL(string: "https://example.com")!)
    }
}

