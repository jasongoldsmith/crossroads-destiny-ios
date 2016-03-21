//
//  TRApplicationManager.swift
//  Traveler
//
//  Created by Ashutosh on 2/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger


class TRApplicationManager: NSObject {
    
    // MARK:- Instances
    
    private let TIMER_INTERVAL: Double = 5
    private var timer: NSTimer = NSTimer()

    // Shared Instance
    static let sharedInstance = TRApplicationManager()
    
    //XCGLogger Instance
    let log = XCGLogger.defaultInstance()
    
    //StoryBoard Manager Instance
    let stroryBoardManager = TRStoryBoardManager()
    
    //Event Info Objet
    var eventsList: [TREventInfo] = []
    
    //Activity List
    var activityList: [TRActivityInfo] = []
    
    //Image Helper
    var imageHelper = ImageHelper()
    
    // Activity Indicator
    var activityIndicator = TRActivityIndicatorView()
    
    
    // Error Notification View 
    var errorNotificationView = TRErrorNotificationView()
    
    
    // Push Notification View
    var pushNotificationView = TRPushNotificationView()
    
    
    
    // MARK:- Initializer
    private override init() {
        super.init()
        
        #if DEBUG
            self.log.setup(.Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
            self.log.xcodeColorsEnabled = true
        #else
            self.log.setup(.Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        #endif
        
        // Init Activity Indicator with nib
        self.activityIndicator = NSBundle.mainBundle().loadNibNamed("TRActivityIndicatorView", owner: self, options: nil)[0] as! TRActivityIndicatorView
        
        // Init Error Notification View with nib
        self.errorNotificationView = NSBundle.mainBundle().loadNibNamed("TRErrorNotificationView", owner: self, options: nil)[0] as! TRErrorNotificationView
        
        // Init Push Notification View with nib
        self.pushNotificationView = NSBundle.mainBundle().loadNibNamed("TRPushNotificationView", owner: self, options: nil)[0] as! TRPushNotificationView
    }

    
    func addNotificationViewWithMessages (parentView: TRBaseViewController, sender: NSNotification) -> TRPushNotificationView {
        
        let xAxiDistance:CGFloat  = 0
        let yAxisDistance:CGFloat = 130
        self.pushNotificationView.frame = CGRectMake(xAxiDistance, yAxisDistance, parentView.view.frame.width, self.pushNotificationView.frame.height)
        self.pushNotificationView.removeFromSuperview()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(TIMER_INTERVAL, target: self, selector: "notificationTimer", userInfo: nil, repeats: false)
        
        if let userInfo = sender.userInfo as NSDictionary? {
            if let payload = userInfo.objectForKey("payload") as? NSDictionary {
                if let eType = payload.objectForKey("eType") as? NSDictionary {
                    if let eventType = eType.objectForKey("aType") as? String {
                        self.pushNotificationView.eventStatusDescription.text = eventType
                    }
                }
            }
            if let apsData = userInfo.objectForKey("aps") as? NSDictionary {
                self.pushNotificationView.eventStatusLabel.text =  apsData.objectForKey("alert") as? String
            }
        }
        
        return self.pushNotificationView
    }
    
    
    func notificationTimer() {
        
        self.pushNotificationView.removeFromSuperview()
        self.timer.invalidate()
    }
    
    func addErrorSubViewWithMessage(errorString: String) {
        self.errorNotificationView.addErrorSubViewWithMessage(errorString)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:- Data Helper Methods
    func getEventById (eventId: String) -> TREventInfo? {

        let eventObjectArray = TRApplicationManager.sharedInstance.eventsList.filter{$0.eventID == eventId}
        return eventObjectArray.first
    }
    
    func isCurrentPlayerInAnEvent (event: TREventInfo) -> Bool {
        
        let found = event.eventPlayersArray.filter {$0.playerID == TRUserInfo.getUserID()}
        if found.count > 0 {
            return true
        }

        return false
    }
    
    func isCurrentPlayerCreatorOfTheEvent (event: TREventInfo) -> Bool {
        if event.eventCreator?.playerID == TRUserInfo.getUserID() {
            return true
        }
        
        return false
    }
    
    // Rewrite this method- User Server Login Response to save userID, psnID, UserImage
    func getPlayerObjectForCurrentUser () -> TRPlayerInfo? {
        for event in self.eventsList {
            for player in event.eventPlayersArray {
                if player.playerID == TRUserInfo.getUserID() {
                    return player
                }
            }
        }
        
        return nil
    }
    
    // Filter Activity Array Based on ActivityType
    func getActivitiesOfType (activityType: String) -> [TRActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activityType == activityType}
        return activityArray
    }
    
    func getActivitiesMatchingSubTypeAndLevel(activity: TRActivityInfo) -> [TRActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activitySubType == activity.activitySubType && $0.activityDificulty == activity.activityDificulty}
        return activityArray
    }
    
    func purgeSavedData () {
        self.activityList.removeAll()
        self.eventsList.removeAll()
    }
}

