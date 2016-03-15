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
 
    func createAnEventWithActivity (activity: TRActivityInfo, completion: TRValueCallBack) {
        
        let createEventUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_EventCreationUrl
        
        //Add Parameters
        var params = [String: AnyObject]()
        params["eType"] = activity.activityID!
        params["minPlayers"] = 1
        params["maxPlayers"] = 6
        params["creator"] = TRUserInfo.getUserID()
        
        let player = TRUserInfo.getUserID()
        params["players"] = ["\(player!)"]
        
        request(.POST, createEventUrl, parameters:params)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        
                        if swiftyJsonVar.isEmpty {
                            completion(value: false )
                        } else if swiftyJsonVar["responseType"].string == "ERR" {
                            
                            if swiftyJsonVar["error"].string == "Player is already in the event" {
                                completion(value: true)
                                return
                            }
                            
                            completion(value: false )
                        } else {

                            // Creating Event Objects from Events List
                            let eventInfo = TREventInfo()
                           
                            eventInfo.eventID           = swiftyJsonVar["_id"].string
                            eventInfo.eventUpdatedDate  = swiftyJsonVar["updated"].string
                            eventInfo.eventMaxPlayers   = swiftyJsonVar["maxPlayers"].number
                            eventInfo.eventMinPlayer    = swiftyJsonVar["minPlayers"].number
                            eventInfo.eventCreatedDate  = swiftyJsonVar["created"].string
                            eventInfo.eventStatus       = swiftyJsonVar["status"].string
                            
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
                            
                            //Adding it to "eventsInfo"
                            let eventToUpdate = TRApplicationManager.sharedInstance.getEventById(eventInfo.eventID!)
                            if let _ = eventToUpdate {
                                let eventIndex = TRApplicationManager.sharedInstance.eventsList.indexOf(eventToUpdate!)
                                TRApplicationManager.sharedInstance.eventsList.removeAtIndex(eventIndex!)
                            }

                            TRApplicationManager.sharedInstance.eventsList.insert(eventInfo, atIndex: 0)
                            completion(value: true )
                        }
                    } else {
                        completion(value: false )
                    }
                }
                else
                {
                    completion(value: false )
                }
        }
    }
}