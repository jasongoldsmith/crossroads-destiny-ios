//
//  TRGetEventsList.swift
//  Traveler
//
//  Created by Ashutosh on 2/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TRGetEventsList: TRRequest {
    
    func getEventsList (completion: TRValueCallBack) {
        
        let eventListingUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_EventListUrl
        
        request(.GET, eventListingUrl, parameters:nil)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        
                        if swiftyJsonVar.isEmpty {
                            completion(value: false )
                    } else if swiftyJsonVar["responseType"].string == "ERR" {
                        completion(value: false )
                    } else {
                            for events in swiftyJsonVar.arrayValue {
                                
                                // Creating Event Objects from Events List
                                let eventInfo = TREventInfo()
                                eventInfo.eventID           = events["_id"].string
                                eventInfo.eventStatus       = events["status"].string
                                eventInfo.eventUpdatedDate  = events["updated"].string
                                eventInfo.eventMaxPlayers   = events["maxPlayers"].number
                                eventInfo.eventMinPlayer    = events["minPlayers"].number
                                eventInfo.eventCreatedDate  = events["created"].string
                                
                                // Dictionary of Activities in an Event
                                let activityDictionary = events["eType"].dictionary
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
                                let creatorDictionary = events["creator"].dictionary
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
                                
                                let playersArray = events["players"].arrayValue
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
                                TRApplicationManager.sharedInstance.eventsList.append(eventInfo)
                            }
                            
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