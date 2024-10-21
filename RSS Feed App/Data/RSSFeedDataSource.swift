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
    
    // Methods for handling favorites
    func saveFavoriteURLs(_ urls: [URL])
    func loadFavoriteURLs() -> [URL]
    func addFavoriteURL(_ url: URL)
    func removeFavoriteURL(_ url: URL)
    func isFavoriteURL(_ url: URL) -> Bool
}

final class RSSFeedDataSource: RSSFeedDataSourceProtocol {
    private let userDefaultsKey = "savedFeedURLs"
    private let favoritesKey = "favoriteFeedURLs"
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
    
    func saveFavoriteURLs(_ urls: [URL]) {
        let urlStrings = urls.map { $0.absoluteString }
        userDefaults.set(urlStrings, forKey: favoritesKey)
    }
    
    func loadFavoriteURLs() -> [URL] {
        guard let urlStrings = userDefaults.stringArray(forKey: favoritesKey) else {
            return []
        }
        return urlStrings.compactMap { URL(string: $0) }
    }
    
    func addFavoriteURL(_ url: URL) {
        var favorites = loadFavoriteURLs()
        if !favorites.contains(url) {
            favorites.append(url)
            saveFavoriteURLs(favorites)
        }
    }
    
    func removeFavoriteURL(_ url: URL) {
        var favorites = loadFavoriteURLs()
        favorites.removeAll(where: { $0.absoluteString == url.absoluteString })
        saveFavoriteURLs(favorites)
    }
    
    func isFavoriteURL(_ url: URL) -> Bool {
        return loadFavoriteURLs().contains(url)
    }
}
