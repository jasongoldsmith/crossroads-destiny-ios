//
//  TRLeaveEventRequest.swift
//  Traveler
//
//  Created by Ashutosh on 3/5/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class TRLeaveEventRequest: TRRequest {
    
    func leaveAnEvent (eventInfo: TREventInfo, completion: TRValueCallBack) {
        
        let leaveEventtUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LeaveEventUrl
        
        var params = [String: AnyObject]()
        params["eId"]    = eventInfo.eventID
        params["player"] = TRUserInfo.getUserID()
        
        
        
        let request = TRRequest()
        request.params = params
        request.requestURL = leaveEventtUrl
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.errorNotificationView.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            guard let _ = swiftyJsonVar["_id"].string else {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("No Event Received")
    
                return
            }
            
            // Creating Event Objects from Events List
            let existingEvent = TRApplicationManager.sharedInstance.getEventById(swiftyJsonVar["_id"].string!)
            
            
            // If there's no creator info in the JSON feed then it means you were the last person in the event and since you left
            // the whole event has been deleted.
            let creatorDict = swiftyJsonVar["creator"].dictionary
            if (creatorDict == nil) {
                if existingEvent != nil {
                    TRApplicationManager.sharedInstance.eventsList.removeAtIndex(TRApplicationManager.sharedInstance.eventsList.indexOf(existingEvent!)!)
                }
                completion(didSucceed: true)
                
                return
            }
            
            if let _ = existingEvent {
                existingEvent?.eventID           = swiftyJsonVar["_id"].string
                existingEvent?.eventStatus       = swiftyJsonVar["status"].string
                existingEvent?.eventUpdatedDate  = swiftyJsonVar["updated"].string
                existingEvent?.eventMaxPlayers   = swiftyJsonVar["maxPlayers"].number
                existingEvent?.eventMinPlayer    = swiftyJsonVar["minPlayers"].number
                existingEvent?.eventCreatedDate  = swiftyJsonVar["created"].string
                
                // Dictionary of Activities in an Event
                let activityDictionary = swiftyJsonVar["eType"].dictionary
                if let activity = activityDictionary {
                    let activityInfo = TRActivityInfo()
                    
                    activityInfo.activityID         = activity["_id"]?.stringValue
                    activityInfo.activitySubType    = activity["aSubType"]?.stringValue
                    activityInfo.activityCheckPoint = activity["aLight"]?.stringValue
                    activityInfo.activityType       = activity["aType"]?.stringValue
                    activityInfo.activityDificulty  = activity["aDifficulty"]?.stringValue
                    activityInfo.activityLight      = activity["aLight"]?.number
                    activityInfo.activityMaxPlayers = activity["maxPlayers"]?.number
                    activityInfo.activityMinPlayers = activity["minPlayers"]?.number
                    activityInfo.activityIconImage  = activity["aIconUrl"]?.stringValue
                    
                    //Event Activity added
                    existingEvent?.eventActivity = activityInfo
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
                    existingEvent?.eventCreator = creatorInfo
                }
                
                //Delete the player Array and add new updated one
                existingEvent?.eventPlayersArray.removeAll()
                
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
                    existingEvent?.eventPlayersArray.append(playerInfo)
                }
            }
            completion(didSucceed: true )
        }
    }
}