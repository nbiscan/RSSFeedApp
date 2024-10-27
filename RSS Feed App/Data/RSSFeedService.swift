//
//  RSSFeedService.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 16.10.2024..
//

import Foundation

protocol RSSFeedServiceProtocol {
    func fetchFeed(from url: URL) async throws -> RSSFeed
}

final class RSSFeedService: NSObject, RSSFeedServiceProtocol {
    private var currentElement: String = ""
    private var currentTitle: String = ""
    private var currentDescription: String = ""
    private var currentLink: String = ""
    private var currentImageUrl: String?
    private var channelImageUrl: String?
    private var items: [RSSItem] = []
    
    private var feedTitle: String = ""
    private var feedDescription: String = ""
    private var originalFeedURL: URL?
    
    func fetchFeed(from url: URL) async throws -> RSSFeed {
        items.removeAll()
        feedTitle = ""
        feedDescription = ""
        channelImageUrl = nil
        originalFeedURL = url
        
        guard let data = try? await fetchData(from: url) else {
            throw NetworkError.invalidData
        }
        
        try parseFeed(data)
        
        return RSSFeed(
            title: feedTitle,
            description: feedDescription,
            imageUrl: URL(string: channelImageUrl ?? ""),
            url: originalFeedURL ?? URL(string: "")!,
            isFavorite: false,
            notificationsEnabled: false,
            items: items
        )
    }
    
    private func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
    
    private func parseFeed(_ data: Data) throws {
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        guard parser.parse() else {
            if parser.parserError != nil {
                throw NetworkError.parsingError
            } else {
                throw NetworkError.invalidData
            }
        }
    }
}

extension RSSFeedService: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        
        if elementName == "item" {
            currentTitle = ""
            currentDescription = ""
            currentLink = ""
            currentImageUrl = nil
        }
        
        if elementName == "enclosure",
           let url = attributeDict["url"],
           attributeDict["type"]?.hasPrefix("image") == true {
            currentImageUrl = url
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            if feedTitle.isEmpty {
                feedTitle += string
            } else {
                currentTitle += string
            }
        case "description":
            if feedDescription.isEmpty {
                feedDescription += string
            } else {
                currentDescription += string
            }
        case "link":
            currentLink += string
        case "url":
            if currentImageUrl == nil {
                currentImageUrl = string
            }
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(
                title: currentTitle,
                description: currentDescription,
                imageUrl: URL(string: currentImageUrl ?? ""),
                link: URL(string: currentLink.trimmingCharacters(in: .whitespacesAndNewlines))!
            )
            items.append(rssItem)
        }
        if elementName == "image" {
            channelImageUrl = currentImageUrl
        }
    }
}
