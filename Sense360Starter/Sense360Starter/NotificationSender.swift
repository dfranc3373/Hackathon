//
//  NotificationSender.swift
//  Sense360StarterSwift
//
//  Created by Sense360 on 6/25/15.
//  Copyright (c) 2015 Sense360. All rights reserved.
//

import Foundation
import UIKit

class NotificationSender {
    
    class func send(text: String) {
        
        let alert = UIAlertView(title: "Notification Alert", message: "Check your notification tray", delegate:self, cancelButtonTitle: "Ok")
        alert.show()
        
        let notification = UILocalNotification()
        
        notification.alertBody = text
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil))
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
}