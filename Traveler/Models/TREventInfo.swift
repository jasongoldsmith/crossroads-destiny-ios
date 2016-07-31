//
//  TREventInfo.swift
//  Traveler
//
//  Created by Ashutosh on 2/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TREventInfo: NSObject {

    var eventID                 : String?
    var eventStatus             : String?
    var eventUpdatedDate        : String?
    var eventV                  : String?
    var eventMaxPlayers         : NSNumber?
    var eventMinPlayer          : NSNumber?
    var eventCreatedDate        : String?
    var eventLaunchDate         : String?
    var eventActivity           : TRActivityInfo?
    var eventCreator            : TRCreatorInfo?
    var eventPlayersArray       : [TRPlayerInfo] = []
    var isFutureEvent           : Bool = false
    var eventClanID             : String?
    var eventConsoleType        : String?
    
    func parseCreateEventInfoObject (swiftyJason: JSON) -> TREventInfo {
        
        // Creating Event Objects from Events List
        self.eventID           = swiftyJason["_id"].stringValue
        self.eventStatus       = swiftyJason["status"].stringValue
        self.eventUpdatedDate  = swiftyJason["updated"].stringValue
        self.eventMaxPlayers   = swiftyJason["maxPlayers"].numberValue
        self.eventMinPlayer    = swiftyJason["minPlayers"].numberValue
        self.eventCreatedDate  = swiftyJason["created"].stringValue
        self.eventLaunchDate   = swiftyJason["launchDate"].stringValue
        self.eventClanID       = swiftyJason["clanId"].stringValue
        self.eventConsoleType  = swiftyJason["consoleType"].stringValue
        
        if (swiftyJason["launchStatus"].string == EVENT_TIME_STATUS.UP_COMING.rawValue) {
            self.isFutureEvent = true
        }
        
        // Dictionary of Activities in an Event
        let activityDictionary = swiftyJason["eType"].dictionary
        if let activity = activityDictionary {
            let activityInfo = TRActivityInfo()
            
            activityInfo.activityID         = activity["_id"]?.stringValue
            activityInfo.activitySubType    = activity["aSubType"]?.stringValue
            activityInfo.activityCheckPoint = activity["aCheckpoint"]?.stringValue
            activityInfo.activityType       = activity["aType"]?.stringValue
            activityInfo.activityDificulty  = activity["aDifficulty"]?.stringValue
            activityInfo.activityLight      = activity["aLight"]?.numberValue
            activityInfo.activityMaxPlayers = activity["maxPlayers"]?.numberValue
            activityInfo.activityMinPlayers = activity["minPlayers"]?.numberValue
            activityInfo.activityIconImage  = activity["aIconUrl"]?.stringValue
            activityInfo.activityIsFeatured = activity["isFeatured"]?.boolValue
            activityInfo.activitylocation   = activity["location"]?.stringValue
            activityInfo.activityLevel      = activity["aLevel"]?.stringValue
            
            //Event Activity added
            self.eventActivity = activityInfo
        }
        
        // Creating Creator Object from Events List
        let creatorDictionary = swiftyJason["creator"].dictionary
        if let creator = creatorDictionary {
            let creatorInfo = TRCreatorInfo()
            
            creatorInfo.playerID        = creator["_id"]?.stringValue
            creatorInfo.playerUserName  = creator["userName"]?.stringValue
            creatorInfo.playerDate      = creator["date"]?.stringValue
            //creatorInfo.playerPsnID     = creator["psnId"]?.stringValue
            creatorInfo.playerUdate     = creator["uDate"]?.stringValue
            
            for consoles in creator["consoles"]!.arrayValue {
                let creatorConsole = TRConsoles()
                creatorConsole.consoleId = consoles["consoleId"].stringValue
                creatorConsole.consoleType = consoles["consoleType"].stringValue
                creatorConsole.verifyStatus = consoles["verifyStatus"].stringValue
                
                creatorInfo.playerConsoles.append(creatorConsole)
            }
            
            //TODO: REMOVE FIRST OBJECT
            creatorInfo.playerPsnID = creatorInfo.playerConsoles.first?.consoleId
            
            // Event Creator Added
            self.eventCreator = creatorInfo
        }
        
        // Delete players Array
        self.eventPlayersArray.removeAll()
        
        let playersArray = swiftyJason["players"].arrayValue
        for playerInfoObject in playersArray {
            let playerInfo = TRPlayerInfo()
            
            playerInfo.playerID         = playerInfoObject["_id"].stringValue
            playerInfo.playerUserName   = playerInfoObject["userName"].stringValue
            playerInfo.playerDate       = playerInfoObject["date"].stringValue
            playerInfo.playerUdate      = playerInfoObject["uDate"].stringValue
            playerInfo.playerImageUrl   = playerInfoObject["imageUrl"].stringValue
            
            for consoles in playerInfoObject["consoles"].arrayValue {
                let playerConsole = TRConsoles()
                playerConsole.consoleId = consoles["consoleId"].stringValue
                playerConsole.consoleType = consoles["consoleType"].stringValue
                playerConsole.verifyStatus = consoles["verifyStatus"].stringValue
                
                playerInfo.playerConsoles.append(playerConsole)
            }
            
            //TODO: REMOVE FIRST OBJECT
            playerInfo.playerPsnID = playerInfo.playerConsoles.first?.consoleId
            
            // Players of an Event Added
            self.eventPlayersArray.append(playerInfo)
        }
        
        return self
    }
 
    func isEventFull () throws -> Bool {
        
        if self.eventPlayersArray.count < self.eventMaxPlayers?.integerValue {
            return false
        }
        
        throw Branch_Error.MAXIMUM_PLAYERS_REACHED
    }
    
    func isEventGroupPartOfUsersGroups () throws -> Bool {
        
        if self.eventClanID == TRUserInfo.getUserClanID() {
            return false
        }
        
        throw Branch_Error.JOIN_BUNGIE_GROUP
    }
    
    func isEventConsoleMatchesUserConsole() throws -> Bool {
        
        if self.eventConsoleType == TRUserInfo.getConsoleType() {
            return false
        }
        
        throw Branch_Error.NEEDS_CONSOLE
    }
}


