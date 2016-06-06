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
    
    func parseCreateEventInfoObject (swiftyJason: JSON) -> TREventInfo {
        return self.createEventObjectFromFireBaseWithEventID(swiftyJason, fireBaseEventID: nil)
    }
    
    func createEventObjectFromFireBaseWithEventID (swiftyJason: JSON, fireBaseEventID: String?) -> TREventInfo {
        
        // Creating Event Objects from Events List
        if let _ = fireBaseEventID {
            self.eventID           = fireBaseEventID
        } else {
            self.eventID           = swiftyJason["_id"].string
        }
        self.eventStatus       = swiftyJason["status"].string
        self.eventUpdatedDate  = swiftyJason["updated"].string
        self.eventMaxPlayers   = swiftyJason["maxPlayers"].number
        self.eventMinPlayer    = swiftyJason["minPlayers"].number
        self.eventCreatedDate  = swiftyJason["created"].string
        self.eventLaunchDate   = swiftyJason["launchDate"].string
        self.eventClanID       = swiftyJason["clanId"].string
        
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
            activityInfo.activityLight      = activity["aLight"]?.number
            activityInfo.activityMaxPlayers = activity["maxPlayers"]?.number
            activityInfo.activityMinPlayers = activity["minPlayers"]?.number
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
            creatorInfo.playerPsnID     = creator["psnId"]?.stringValue
            creatorInfo.playerUdate     = creator["uDate"]?.stringValue
            
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
                playerConsole.consoleId = consoles[""].stringValue
                playerConsole.consoleType = consoles[""].stringValue
                playerConsole.verifyStatus = consoles[""].stringValue
                
                playerInfo.playerConsoles.append(playerConsole)
            }
            
            //TODO: REMOVE FIRST OBJECT
            playerInfo.playerPsnID = playerInfo.playerConsoles.first?.consoleId
            
            // Players of an Event Added
            self.eventPlayersArray.append(playerInfo)
        }
        
        return self
    }
}


