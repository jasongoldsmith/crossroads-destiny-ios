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
import Alamofire
import SlideMenuControllerSwift
import SwiftyJSON


class TRApplicationManager: NSObject {
    
    // MARK:- Instances
    
    private let REQUEST_TIME_OUT = 30.0
    private let UPCOMING_EVENT_TIME_THREASHOLD = 1
    
    // Shared Instance
    static let sharedInstance = TRApplicationManager()
    
    //XCGLogger Instance
    let log = XCGLogger.defaultInstance()
    
    //StoryBoard Manager Instance
    let stroryBoardManager = TRStoryBoardManager()
    
    //Event Info Objet
    lazy var eventsList: [TREventInfo] = []
    
    //Activity List
    lazy var activityList: [TRActivityInfo] = []
    
    // Activity Indicator
    var activityIndicator = TRActivityIndicatorView()
    
    // Error Notification View 
    var errorNotificationView = TRErrorNotificationView()
    
    
    // Push Notification View
    var pushNotificationView = TRPushNotificationView()

    //AlamoreFire Manager
    var alamoFireManager : Alamofire.Manager?
    
    // SlideMenu Controller
    var slideMenuController = SlideMenuController()
    
    //FireBase Class Instance
    var fireBaseObj = TRFireBaseListener()
    
    // MARK:- Initializer
    private override init() {
        super.init()
        
        // Network Configuration
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = REQUEST_TIME_OUT
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        self.alamoFireManager = Alamofire.Manager(configuration: configuration)

        
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

    func addSlideMenuController(parentViewController: TRBaseViewController, pushData: NSDictionary?) {

        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier(K.ViewControllerIdenifier.VIEW_CONTROLLER_PROFILE) as! TRProfileViewController
        let eventListViewController = storyboard.instantiateViewControllerWithIdentifier(K.ViewControllerIdenifier.VIEWCONTROLLER_EVENT_LIST) as! TREventListViewController
        
        self.slideMenuController = SlideMenuController(mainViewController:eventListViewController, rightMenuViewController: profileViewController)
        self.slideMenuController.automaticallyAdjustsScrollViewInsets = true
        self.slideMenuController.closeRight()
        self.slideMenuController.rightPanGesture?.enabled = false
        self.slideMenuController.changeRightViewWidth(340.0)
        
        var animated = false
        if let _ = pushData {
            if let _ = pushData!.objectForKey("payload") as? NSDictionary {
                animated = true
            }
        }
        
        self.slideMenuController.view.alpha = 0
        parentViewController.presentViewController(self.slideMenuController, animated: animated, completion: {
            
            if let _ = pushData {
                self.slideMenuController.view.alpha = 1
                if let payload = pushData!.objectForKey("payload") as? NSDictionary{
                    if let eventDict = payload.objectForKey("event") {
                        let swiftyJson = JSON(eventDict)
                        let eventInfo = TREventInfo().parseCreateEventInfoObject(swiftyJson)
                        eventListViewController.showEventInfoViewController(eventInfo)
                    } else {
                        let swiftyJson = JSON(payload)
                        let eventInfo = TREventInfo().parseCreateEventInfoObject(swiftyJson)
                        if eventInfo.eventID != nil {
                            eventListViewController.showEventInfoViewController(eventInfo)
                        }
                    }
                }
            } else {
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : TRCreateEventViewController = storyboard.instantiateViewControllerWithIdentifier(K.ViewControllerIdenifier.VIEWCONTROLLER_CREATE_EVENT) as! TRCreateEventViewController
                let navigationController = UINavigationController(rootViewController: vc)
                eventListViewController.presentViewController(navigationController, animated: false, completion: {
                self.slideMenuController.view.alpha = 1
                })
            }
        })
    }
    
    func addNotificationViewWithMessages (sender: NSNotification) {
        
        return self.pushNotificationView.addNotificationViewWithMessages(sender)
    }
    
    
    func addErrorSubViewWithMessage(errorString: String) {
        self.errorNotificationView.errorSting = errorString
        self.errorNotificationView.addErrorSubViewWithMessage()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:- Data Helper Methods
    func isTimeDifferenceMoreThenAnHour(dateString: String) -> Bool {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let eventDate = formatter.dateFromString(dateString) {
            eventDate.dateBySubtractingHours(UPCOMING_EVENT_TIME_THREASHOLD)
            
            if eventDate.isInFuture() {
                return true
            }
        }
        
        return false
    }
    
    
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
    
    // Rewrite this method- User Server Login Response to save userID, psnID, UserImage -- ASHU
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
    
    //Filter Current Events
    func getCurrentEvents () -> [TREventInfo] {
        let currentInfo = self.eventsList.filter{$0.isFutureEvent == false}
        return currentInfo
    }

    //Filter Future Events
    func getFutureEvents () -> [TREventInfo] {
        let futureInfo = self.eventsList.filter{$0.isFutureEvent == true}
        return futureInfo
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
    
    func getFeaturedActivities () -> [TRActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activityIsFeatured == true}
        return activityArray
    }
    
    func purgeSavedData () {
        self.activityList.removeAll()
        self.eventsList.removeAll()
    }
}

