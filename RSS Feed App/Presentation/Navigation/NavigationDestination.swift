//
//  NavigationDestination.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 07.11.2024..
//

import SwiftUI

enum NavigationDestination: Hashable {
    case rssFeedDetails(RSSFeedDetailsViewModel)
    case webView(URL)
}
