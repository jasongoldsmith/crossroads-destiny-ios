//
//  TRFireBaseManager.swift
//  Traveler
//
//  Created by Ashutosh on 7/7/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class TRFireBaseManager {
    
    var ref: FIRDatabaseReference?
    typealias TRFireBaseSuccessCallBack = (didCompelete: Bool?) -> ()
    
    //Initialize FireBase Configuration
    func initFireBaseConfig () {
        FIRApp.configure()
    }
    
    
    func addUserObserverWithCompletion (complete: TRFireBaseSuccessCallBack) {
        if let userID = TRUserInfo.getUserID() {
            let endPointKeyReference = userID
            self.ref = FIRDatabase.database().reference().child("users/").child(endPointKeyReference)
            self.ref?.observeEventType(.Value, withBlock: { (snapshot) in
               
                if let snap = snapshot.value as? NSDictionary {
                    let userData = TRUserInfo()
                    let snapShotJson = JSON(snap)
                    userData.parseUserResponse(snapShotJson)
                    
                    for console in userData.consoles {
                        if console.isPrimary == true {
                            TRUserInfo.saveConsolesObject(console)
                        }
                    }
                    
                    TRUserInfo.saveUserData(userData)
                    
                    complete(didCompelete: true)
                }
            })
        }
    }
    
    func addEventsObserversWithParentView (parentViewController: TRBaseViewController) {
        
//        guard let userClan = TRUserInfo.getUserClanID() else {
//            return
//        }
//        
//        let endPointKeyReference = userClan
//        self.ref = FIRDatabase.database().reference().child("events/").child(endPointKeyReference)
//        self.ref?.observeEventType(.Value, withBlock: { (snapshot) in
//            _ = TRGetEventsList().getEventsListWithClearActivityBackGround (false, clearBG: true, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
//                if(didSucceed == true) {
//                    dispatch_async(dispatch_get_main_queue(), {
//                        parentViewController.reloadEventTable()
//                    })
//                } else {
//                    
//                }
//            })
//        })
    }
    
    func addEventsObserversWithParentViewForDetailView (parentViewController: TREventInformationViewController, withEvent: TREventInfo) {
        
        guard let hasEventClan = withEvent.eventClanID else {
            return
        }
        
        guard let hasEventID = withEvent.eventID else {
            return
        }
        
        
        let endPointKeyReference = hasEventClan + "/" + hasEventID
        self.ref = FIRDatabase.database().reference().child("events/").child(endPointKeyReference)
        self.ref?.observeEventType(.Value, withBlock: { (snapshot) in
//            if snapshot.value is NSNull {
//                parentViewController.dismissViewController(true, dismissed: { (didDismiss) in
//                    
//                })
//                return
//            }

            // FETCH EVENT OBJECT
            _ = TRGetEventRequest().getEventByID(hasEventID, viewHandlesError: false, showActivityIndicator: false, completion: { (error, event) in
                if let _ = event {
                    parentViewController.eventInfo = event
                    dispatch_async(dispatch_get_main_queue(), {
                        parentViewController.reloadEventTable()
                    })
                }
            })
        })
    }
    
    func removeObservers () {
        self.ref?.removeAllObservers()
    }
}
