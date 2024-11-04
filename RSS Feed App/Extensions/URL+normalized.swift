//
//  URL+normalized.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 04.11.2024..
//

import Foundation

extension URL {
    var normalized: URL {
        guard scheme == nil else { return self }
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        return components?.url ?? self
    }
}
