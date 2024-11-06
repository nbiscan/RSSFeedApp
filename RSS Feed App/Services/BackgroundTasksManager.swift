//
//  RSSBackgroundManager.swift
//  RSS Feed App
//
//  Created by Natko Biscan on 05.11.2024..
//

import Foundation
import BackgroundTasks
import UserNotifications

protocol BackgroundTaskManagerProtocol {
    func registerTasks()
    func registerBackgroundTasks()
    func scheduleFeedRefresh()
    func handleFeedRefreshTask(task: BGAppRefreshTask) async
}

final class BackgroundTasksManager: BackgroundTaskManagerProtocol {
    static let shared = BackgroundTasksManager()
    
    private init() {}
    
    func registerTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.BackgroundTasks.feedRefreshIdentifier,
                                        using: nil) { task in
            guard let appRefreshTask = task as? BGAppRefreshTask else {
                task.setTaskCompleted(success: false)
                return
            }
            
            Task {
                await self.handleRefreshTask(task: appRefreshTask)
            }
        }
    }
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.BackgroundTasks.feedRefreshIdentifier,
                                        using: nil) { task in
            guard let appRefreshTask = task as? BGAppRefreshTask else {
                task.setTaskCompleted(success: false)
                return
            }
            
            Task {
                await self.handleFeedRefreshTask(task: appRefreshTask)
            }
        }
    }
    
    func scheduleFeedRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Constants.BackgroundTasks.feedRefreshIdentifier)
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
        let feeds = repository.getLocalFeeds().filter { $0.notificationsEnabled }
        
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
    
    private func sendNotification(for feed: RSSFeed, newItems: [RSSItem], after delay: TimeInterval = 5) {
        let content = UNMutableNotificationContent()
        content.title = "New items in \(feed.title)"
        content.body = newItems.count == 1
        ? "There is 1 new item in your subscribed feed."
        : "There are \(newItems.count) new items in your subscribed feed."
        content.sound = .default
        content.userInfo = ["feedURL": feed.url.absoluteString]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "\(feed.identifier)-newItems",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled successfully for \(delay) seconds delay.")
            }
        }
    }
    
    private func handleRefreshTask(task: BGAppRefreshTask) async {
        task.setTaskCompleted(success: true)
    }
    
    // Testing methods
    
    func simulateNotification(withDelay seconds: TimeInterval = 5) {
        let testFeed = RSSFeed.mock
        let newItems = [RSSItem.mock]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.sendNotification(for: testFeed, newItems: newItems)
        }
    }
    
    func simulateNotification() {
        let testFeed = RSSFeed.mock
        let newItems = [RSSItem.mock]
        
        sendNotification(for: testFeed, newItems: newItems)
    }
}
