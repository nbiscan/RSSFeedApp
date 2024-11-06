//
//  Constants.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 05.11.2024..
//

import Foundation

struct Constants {
    struct URLs {
        static let testingRSSURL = "https://example.com/feed.xml"
    }
    
    struct Storage {
        static let key = "savedFeeds"
    }
    
    struct BackgroundTasks {
        static let feedRefreshIdentifier = "com.natkobiscan.RSS-Feed-App.refreshFeeds"
    }
}
