//
//  RSSFeedDataSource.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 19.10.2024..
//

import Foundation

protocol RSSFeedDataSourceProtocol {
    func saveFeedURLs(_ urls: [URL])
    func loadFeedURLs() -> [URL]
    func removeFeedURL(_ url: URL)
}

final class RSSFeedDataSource: RSSFeedDataSourceProtocol {
    private let userDefaultsKey = "savedFeedURLs"
    private let userDefaults = UserDefaults.standard

    func saveFeedURLs(_ urls: [URL]) {
        let urlStrings = urls.map { $0.absoluteString }
        userDefaults.set(urlStrings, forKey: userDefaultsKey)
    }

    func loadFeedURLs() -> [URL] {
        guard let urlStrings = userDefaults.stringArray(forKey: userDefaultsKey) else {
            return []
        }
        return urlStrings.compactMap { URL(string: $0) }
    }

    func removeFeedURL(_ url: URL) {
        var currentURLs = loadFeedURLs()
        currentURLs.removeAll(where: { $0.absoluteString == url.absoluteString })
        saveFeedURLs(currentURLs)
    }
}

