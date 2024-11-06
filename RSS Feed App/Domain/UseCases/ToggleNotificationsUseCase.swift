//
//  ToggleNotificationsUseCase.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 14.10.2024..
//

import Foundation

protocol ToggleNotificationsUseCaseProtocol {
    func execute(feedURL: URL, enable: Bool) async
}

final class ToggleNotificationsUseCase: ToggleNotificationsUseCaseProtocol {
    let repository = RSSFeedRepository.shared

    func execute(feedURL: URL, enable: Bool) async {
        await repository.toggleNotifications(feedURL: feedURL, enable: enable)
    }
}

final class MockToggleNotificationsUseCase: ToggleNotificationsUseCaseProtocol {
    var receivedFeedURL: URL?
    var receivedIsEnabled: Bool?
    
    var onExecute: (() -> Void)?

    func execute(feedURL: URL, enable: Bool) async {
        receivedFeedURL = feedURL
        receivedIsEnabled = enable
        onExecute?()
    }
}
