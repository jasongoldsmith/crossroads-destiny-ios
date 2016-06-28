
//  TRFireBaseListener.swift
//  Traveler
//
//  Created by Ashutosh on 4/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

typealias TRFireBaseSuccessCallBack = (didCompelete: Bool?) -> ()

class TRFireBaseListener {
    
    var firebaseChatData: Firebase?
    
    
    func addUserObserverWithCompletion (complete: TRFireBaseSuccessCallBack) {
        if let userID = TRUserInfo.getUserID() {
            
            let fireBaseUrl = K.TRUrls.TR_FIREBASE_DEFAULT + "users"  + "/" + userID
            self.firebaseChatData = Firebase(url:(fireBaseUrl))
            self.firebaseChatData?.observeEventType(.Value, withBlock: { snap in
                
                if snap.value is NSNull {
                    //something is wrong, not even empty array
                }
                
                if let snapShot = snap.value as? NSDictionary {
                    let userData = TRUserInfo()
                    let snapShotJson = JSON(snapShot)
                    userData.parseUserResponse(snapShotJson)
                    
                    TRUserInfo.saveUserData(userData)
                    
                    complete(didCompelete: true)
                }
            })
        }
    }
    
    func addEventsObserversWithParentView (parentViewController: TRBaseViewController) {

        guard let userClan = TRUserInfo.getUserClanID() else {
            return
        }
        
        let fireBaseUrl = K.TRUrls.TR_FIREBASE_DEFAULT + "events/" + userClan
        self.firebaseChatData = Firebase(url:(fireBaseUrl))
        self.firebaseChatData?.observeEventType(.Value, withBlock: { snap in
            
            _ = TRGetEventsList().getEventsListWithClearActivityBackGround (false, clearBG: true, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
                if(didSucceed == true) {
                    dispatch_async(dispatch_get_main_queue(), {
                        parentViewController.reloadEventTable()
                    })
                } else {
                    
                }
            })
        })
    }
    
    func addEventsObserversWithParentViewForDetailView (parentViewController: TREventInformationViewController, withEvent: TREventInfo) {
        
        guard let hasEventClan = withEvent.eventClanID else {
            return
        }

        guard let hasEventID = withEvent.eventID else {
            return
        }

        let fireBaseUrl = K.TRUrls.TR_FIREBASE_DEFAULT + "events/" + hasEventClan + "/" + hasEventID
        self.firebaseChatData = Firebase(url:(fireBaseUrl))
        self.firebaseChatData?.observeEventType(.Value, withBlock: { snap in

            // FETCH EVENT OBJECT
            _ = TRGetEventRequest().getEventByID(hasEventID, completion: { (event) in
                if let hasEvent = event {
                    parentViewController.eventInfo = hasEvent
                    dispatch_async(dispatch_get_main_queue(), {
                        parentViewController.reloadEventTable()
                    })
                }
            })
        })
    }
    
    func removeObservers () {
        self.firebaseChatData?.removeAllObservers()
    }
}