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
    
    // MARK:- Initializer
    private override init() {
        super.init()
        
        #if DEBUG
            self.log.setup(.Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
            self.log.xcodeColorsEnabled = true
        #else
            self.log.setup(.Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        #endif
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:- Data Helper Methods
    func getEventById (eventId: String) -> TREventInfo? {
        
        for eventObject in TRApplicationManager.sharedInstance.eventsList {
            if eventObject.eventID == eventId {
                return eventObject
            }
        }
        
        return nil
    }
    
    func isCurrentPlayerInAnEvent (event: TREventInfo) -> Bool {
        
        for (_, player) in event.eventPlayersArray.enumerate() {
            if player.playerID == TRUserInfo.getUserID() {
                return true
            }
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
    
    

}

