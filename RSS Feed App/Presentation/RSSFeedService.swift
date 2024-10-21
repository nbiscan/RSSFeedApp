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
    private var items: [RSSItem] = []
    
    private var feedTitle: String = ""
    private var feedDescription: String = ""
    private var originalFeedURL: URL?
    
    private var parserCompletionHandler: ((RSSFeed) -> Void)?
    
    func fetchFeed(from url: URL) async throws -> RSSFeed {
        items.removeAll()
        feedTitle = ""
        feedDescription = ""
        originalFeedURL = url
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
                    return
                }
                
                let parser = XMLParser(data: data)
                parser.delegate = self
                self.parserCompletionHandler = { rssFeed in
                    continuation.resume(returning: rssFeed)
                }
                
                parser.parse()
            }.resume()
        }
    }
}

extension RSSFeedService: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
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
            if parser.parserError == nil {
                if feedTitle.isEmpty {
                    feedTitle += string
                } else {
                    currentTitle += string
                }
            }
        case "description":
            if parser.parserError == nil {
                if feedDescription.isEmpty {
                    feedDescription += string
                } else {
                    currentDescription += string
                }
            }
        case "link":
            if parser.parserError == nil {
                currentLink += string
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
            let rssItem = RSSItem(title: currentTitle,
                                  description: currentDescription,
                                  imageUrl: URL(string: currentImageUrl ?? ""),
                                  link: URL(string: currentLink.trimmingCharacters(in: .whitespacesAndNewlines))!)
            items.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        let feed = RSSFeed(title: feedTitle,
                           description: feedDescription,
                           imageUrl: nil,
                           url: originalFeedURL ?? URL(string: "")!,
                           isFavorite: [true, false].randomElement() ?? false,
                           notificationsEnabled: false,
                           items: items)
        print("Parsed feed: \(feed.url)")
        parserCompletionHandler?(feed)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Failed to parse XML: \(parseError)")
    }
}
