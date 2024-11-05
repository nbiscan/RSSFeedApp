//
//  RSSBackgroundManager.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 05.11.2024..
//

import Foundation
import BackgroundTasks
import UserNotifications

final class RSSBackgroundManager {
    static let shared = RSSBackgroundManager()
    
    private init() {}
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.natkobiscan.RSS-Feed-App.refreshFeeds", using: nil) { task in
            guard let appRefreshTask = task as? BGAppRefreshTask else {
                task.setTaskCompleted(success: false)
                return
            }
            
            Task {
                await self.handleFeedRefreshTask(task: appRefreshTask)
            }
        }
    }
    
    func simulateNotification(withDelay seconds: TimeInterval = 5) {
        let testFeed = RSSFeed.mock
        let newItems = [RSSItem.mock]
        
        print("Simulating notification with a \(seconds) second delay.")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.sendNotification(for: testFeed, newItems: newItems)
        }
    }
    
    
    func simulateNotification() {
        let testFeed = RSSFeed.mock
        let newItems = [RSSItem.mock]
        print("Simulating notification for \(testFeed.title) with \(newItems.count) new items.")
        sendNotification(for: testFeed, newItems: newItems)
    }
    
    func scheduleFeedRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.natkobiscan.RSS-Feed-App.refreshFeeds")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 20 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Scheduled feed refresh task for 20 minutes.")
        } catch {
            print("Could not schedule feed refresh: \(error)")
        }
    }
    
    func handleFeedRefreshTask(task: BGAppRefreshTask) async {
        scheduleFeedRefresh()
        
        let repository = RSSFeedRepository.shared
        let feeds = await repository.getFeeds().filter { $0.notificationsEnabled }
        
        for feed in feeds {
            do {
                let updatedFeed = try await repository.getFeedDetails(feedURL: feed.url)
                
                let newItems = updatedFeed.items.filter { newItem in
                    !feed.items.contains(where: { $0.id == newItem.id })
                }
                
                if !newItems.isEmpty {
                    sendNotification(for: feed, newItems: newItems)
                }
            } catch {
                print("Error fetching feed details for \(feed.title): \(error)")
            }
        }
        
        task.setTaskCompleted(success: true)
    }
    
    private func sendNotification(for feed: RSSFeed, newItems: [RSSItem]) {
        let content = UNMutableNotificationContent()
        content.title = "New items in \(feed.title)"
        content.body = "There are \(newItems.count) new items in your subscribed feed."
        content.sound = .default
        content.userInfo = ["feedURL": feed.url.absoluteString]
        
        let request = UNNotificationRequest(
            identifier: "\(feed.identifier)-newItems",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
}
