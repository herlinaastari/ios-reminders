//
//  Reminder.swift
//  Reminders
//
//  Created by Herlina Astari on 03/03/19.
//  Copyright © 2019 Herlina Astari. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class Reminder: NSObject, NSCoding {
    
    var title: String?
    var time: Date?
    var notification: UNUserNotificationCenter?

    // Persistent Data
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    static let ArchiveURL = DocumentsDirectory?.appendingPathComponent("reminders")
    
    struct PropertyKey {
        static let titleKey = "title"
        static let timeKey = "time"
        static let notificationKey = "notification"
    }
    
    init(title: String, time: Date, notification: UNUserNotificationCenter) {
        self.title = title
        self.time = time
        self.notification = notification
        
        super.init()
    }
    
    deinit {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: PropertyKey.titleKey)
        aCoder.encode(self.time, forKey: PropertyKey.timeKey)
        aCoder.encode(self.notification, forKey: PropertyKey.notificationKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: PropertyKey.titleKey) as! String
        let time = aDecoder.decodeObject(forKey: PropertyKey.timeKey) as! Date
        let notification = aDecoder.decodeObject(forKey: PropertyKey.notificationKey) as! UNUserNotificationCenter
        
        self.init(title: title, time: time, notification: notification)
    }
}
