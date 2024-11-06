//
//  NetworkError.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 26.10.2024..
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid. Please check and try again."
        case .invalidResponse:
            return "The server returned an invalid response. Please try again later."
        case .invalidData:
            return "Failed to load data. Please check your internet connection or try with another URL."
        case .parsingError:
            return "There was an issue parsing the feed. Please try again with another URL."
        }
    }
}
