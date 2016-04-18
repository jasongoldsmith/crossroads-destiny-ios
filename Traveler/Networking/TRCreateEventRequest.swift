//
//  TRCreateEventRequest.swift
//  Traveler
//
//  Created by Ashutosh on 3/1/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class TRCreateEventRequest: TRRequest {
    
    func createAnEventWithActivity (activity: TRActivityInfo, selectedTime: NSDate?, completion: TRValueCallBack) {
        
        let createEventUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_EventCreationUrl
        
        // Current Player
        let player = TRUserInfo.getUserID()
        
        //Add Parameters
        var params = [String: AnyObject]()
        params["eType"] = activity.activityID!
        params["minPlayers"] = activity.activityMinPlayers!
        params["maxPlayers"] = activity.activityMaxPlayers!
        params["creator"] = TRUserInfo.getUserID()
        params["players"] = ["\(player!)"]
        
        if let hasSelectedTime = selectedTime {
            let formatter = NSDateFormatter();
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
            formatter.timeZone = NSTimeZone(abbreviation: "UTC");
            let utcTimeZoneStr = formatter.stringFromDate(hasSelectedTime);
            
            params["launchDate"] = utcTimeZoneStr
        }
        
        
        
        let request = TRRequest()
        request.requestURL = createEventUrl
        request.params = params
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            // Creating Event Objects from Events List
            let eventInfo = TREventInfo()

            guard swiftyJsonVar["_id"].string != nil else {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("No Event ID received")
                
                return
            }
            
            if let isUpComing = swiftyJsonVar["launchStatus"].string {
                if isUpComing == EVENT_TIME_STATUS.UP_COMING.rawValue {
                    eventInfo.isFutureEvent = true
                }
            }

            eventInfo.eventID           = swiftyJsonVar["_id"].string
            eventInfo.eventUpdatedDate  = swiftyJsonVar["updated"].string
            eventInfo.eventMaxPlayers   = swiftyJsonVar["maxPlayers"].number
            eventInfo.eventMinPlayer    = swiftyJsonVar["minPlayers"].number
            eventInfo.eventCreatedDate  = swiftyJsonVar["created"].string
            eventInfo.eventStatus       = swiftyJsonVar["status"].string
            eventInfo.eventLaunchDate   = swiftyJsonVar["launchDate"].string
            
            // Dictionary of Activities in an Event
            let activityDictionary = swiftyJsonVar["eType"].dictionary
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
                
                //Event Activity added
                eventInfo.eventActivity = activityInfo
            }
            
            // Creating Creator Object from Events List
            let creatorDictionary = swiftyJsonVar["creator"].dictionary
            if let creator = creatorDictionary {
                let creatorInfo = TRCreatorInfo()
                
                creatorInfo.playerID        = creator["_id"]?.stringValue
                creatorInfo.playerUserName  = creator["userName"]?.stringValue
                creatorInfo.playerDate      = creator["date"]?.stringValue
                creatorInfo.playerPsnID     = creator["psnId"]?.stringValue
                creatorInfo.playerUdate     = creator["uDate"]?.stringValue
                
                // Event Creator Added
                eventInfo.eventCreator = creatorInfo
            }
            
            let playersArray = swiftyJsonVar["players"].arrayValue
            for playerInfoObject in playersArray {
                let playerInfo = TRPlayerInfo()
                
                playerInfo.playerID         = playerInfoObject["_id"].stringValue
                playerInfo.playerUserName   = playerInfoObject["userName"].stringValue
                playerInfo.playerDate       = playerInfoObject["date"].stringValue
                playerInfo.playerPsnID      = playerInfoObject["psnId"].stringValue
                playerInfo.playerUdate      = playerInfoObject["uDate"].stringValue
                playerInfo.playerImageUrl   = playerInfoObject["imageUrl"].stringValue
                
                // Players of an Event Added
                eventInfo.eventPlayersArray.append(playerInfo)
            }
            
            if let eventToUpdate = TRApplicationManager.sharedInstance.getEventById(eventInfo.eventID!) {
                let eventIndex = TRApplicationManager.sharedInstance.eventsList.indexOf(eventToUpdate)
                TRApplicationManager.sharedInstance.eventsList.removeAtIndex(eventIndex!)
            }
            
            TRApplicationManager.sharedInstance.eventsList.insert(eventInfo, atIndex: 0)

            
            completion(didSucceed: true )
        }
    }
}