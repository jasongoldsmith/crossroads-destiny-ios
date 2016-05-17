//
//  TRPushNotification.swift
//  Traveler
//
//  Created by Ashutosh on 5/16/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRPushNotification {

    var notificationName: String?
    var notificationTrackable: Bool = false
    
    func fetchEventFromPushNotification (pushPayLoad: NSDictionary, complete: TREventObjCallBack) {
        
        if let notiName = pushPayLoad.objectForKey("notificationName") as? String {
            if notiName == NOTIFICATION_NAME.NOTI_LEAVE.rawValue {
                self.notificationName = NOTIFICATION_NAME.NOTI_LEAVE.rawValue
            }
        }

        if let notiTrackable = pushPayLoad.objectForKey("isTrackable") as? Bool {
            if notiTrackable == true {
                self.notificationTrackable = true
            }
        }

        if let eventID = pushPayLoad.objectForKey("eventId") as? String {
            if let eventUpdateTime = pushPayLoad.objectForKey("eventUpdated") as? String {
                if let existingEvent = TRApplicationManager.sharedInstance.getEventById(eventID) {
                    if eventUpdateTime == existingEvent.eventUpdatedDate {
                        //Found Updated Event
                        complete(event: existingEvent)
                    } else {
                        self.getEvent(eventID, completion: { (event) in
                            complete(event: event)
                        })
                    }
                } else {
                    self.getEvent(eventID, completion: { (event) in
                        complete(event: event)
                    })
                }
            }
        }
    }
    
    func getEvent (eventID: String, completion: TREventObjCallBack) {
        _ = TRGetEventByEventID().getEventByID(eventID, completion: { (event) in
            if let _ = event {
                completion(event: event)
            }
        })
    }
}