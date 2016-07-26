//
//  TRActiveStatePushInfo.swift
//  Traveler
//
//  Created by Ashutosh on 7/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRActiveStatePushInfo {
    
    var alertString: String?
    var eventName: String?
    var apsData: NSDictionary?
    var isMessageNotification: Bool?
    var pushId: String?
    var updateTime: String?
    var eventID: String?
    
    func parsePushNotificationPayLoad (sender: NSNotification) {
        if let userInfo = sender.userInfo as NSDictionary? {
            if let payload = userInfo.objectForKey("payload") as? NSDictionary {
                
                
                if let notificationType = payload.objectForKey("notificationName") as? String where notificationType == NOTIFICATION_NAME.NOTI_MESSAGE_PLAYER.rawValue {
                    self.isMessageNotification = true
                } else {
                    self.isMessageNotification = false
                }
                
                if let updateTime = payload.objectForKey("eventUpdated") as? String {
                    self.updateTime = updateTime
                }
                
                if let eventName = payload.objectForKey("eventName") as? String {
                    self.eventName = eventName
                }

                if let eventID = payload.objectForKey("eventId") as? String {
                    self.eventID = eventID
                }

                if let apsData = userInfo.objectForKey("aps") as? NSDictionary {
                    
                    self.apsData = apsData
                    
                    if let alertString = self.apsData?.objectForKey("alert") as? String {
                            self.alertString = alertString
                    }
                }
            }
        }
    }
}

