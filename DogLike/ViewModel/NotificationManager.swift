//
//  NotificationManager.swift
//  DogLike
//
//  Created by Markus Wirtz on 05.11.24.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared: NotificationManager = NotificationManager()
    private init() {}
    
    private let center = UNUserNotificationCenter.current()
    @AppStorage("likeCounter") var likeCounter: Int = 0
    
    private func setupNotificationCategories() {
        let viewAction = UNNotificationAction(identifier: "view",
                                              title: "Ansehen",
                                              options: [.foreground])
        
        let ignoreAction = UNNotificationAction(identifier: "ignore",
                                                title: "Ignorieren",
                                                options: [])
        
        let category = UNNotificationCategory(identifier: "category",
                                              actions: [viewAction, ignoreAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        center.setNotificationCategories([category])
    }
    
    func requestPermission() async throws -> Bool {
        let success = try await self.center.requestAuthorization(options: [.alert, .badge, .sound])
        
        guard success else {
            print("Benachrichtigung nicht erlaubt")
            return false
        }
        print("Benachrichtigung erlaubt")
        self.scheduleDailyNotification()
        self.setupNotificationCategories()
        return true
    }
    
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "DogLike Benachrichtigung"
        content.body = "Schau vorbei und verpass keinen deiner Lieblingshunde."
        content.sound = .default
        content.categoryIdentifier = "category"
        
        var date = DateComponents()
        date.hour = 16
        date.minute = 10
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error {
                print(error)
            }
        }
    }
    
    func likeNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Glückwunsch"
        content.body = "Du hast inzwischen \(likeCounter - 1) Hunde die dir gefallen."
        content.sound = .default
        content.categoryIdentifier = "category"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error {
                print(error)
            }
        }
    }
    
}
