
//  TRFireBaseListener.swift
//  Traveler
//
//  Created by Ashutosh on 4/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class TRFireBaseListener {
    
    var firebaseChatData: Firebase?
    
    
    func addUserObserver () {
        guard let userClan = TRUserInfo.getUserClanID() else {
            return
        }
        
        if let userID = TRUserInfo.getUserID() {
            
            let fireBaseUrl = K.TRUrls.TR_FIREBASE_DEFAULT + "user" + "/" + userClan + "/" + userID
            self.firebaseChatData = Firebase(url:(fireBaseUrl))
            self.firebaseChatData?.observeEventType(.Value, withBlock: { snap in
                
                if snap.value is NSNull {
                    //something is wrong, not even empty array
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
            
            if snap.value is NSNull {
                //something is wrong, not even empty array
            }
            else {
                _ = TRGetEventsList().getEventsListWithClearActivityBackGround (false, clearBG: true, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
                    if(didSucceed == true) {
                        parentViewController.reloadEventTable()
                    } else {
                        
                    }
                })
            }
        })
    }
    
    func removeObservers () {
        self.firebaseChatData?.removeAllObservers()
    }
}