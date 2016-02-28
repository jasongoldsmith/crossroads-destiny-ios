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
                                eventInfo.eventCreated      = events["created"].string
                                
                                // Dictionary of Activities in an Event
                                let activityDictionary = events["eType"].dictionaryValue
                                let activityInfo = TRActivityInfo()
                                activityInfo.activityID         = activityDictionary["_id"]!.stringValue
                                activityInfo.activitySubType    = activityDictionary["aSubType"]!.stringValue
                                activityInfo.activityCheckPoint = activityDictionary["aLight"]!.stringValue
                                activityInfo.activityType       = activityDictionary["aType"]!.stringValue
                                activityInfo.activityDificulty  = activityDictionary["aDifficulty"]!.stringValue
                                activityInfo.activityLight      = activityDictionary["aLight"]!.number
                                activityInfo.activityMaxPlayers = activityDictionary["maxPlayers"]!.number
                                activityInfo.activityMinPlayers = activityDictionary["minPlayers"]!.number
                                
                                //Event Activity added
                                eventInfo.eventActivity = activityInfo
                                
                                let playersArray = events["players"].arrayValue
                                for playerInfoObject in playersArray {
                                    let playerInfo = TRPlayerInfo()
                                    playerInfo.playerID = playerInfoObject["_id"].stringValue
                                    playerInfo.playerUserName = playerInfoObject["userName"].stringValue
                                    playerInfo.playerDate = playerInfoObject["date"].stringValue
                                    playerInfo.playerPsnID = playerInfoObject["psnId"].stringValue
                                    playerInfo.playerUdate = playerInfoObject["uDate"].stringValue
                                    
                                    // Players of an Event Added
                                    eventInfo.eventPlayersArray.append(playerInfo)
                                }
                                
                                //Adding it to "eventsInfo"
                                TRApplicationManager.sharedInstance.eventsInfo.append(eventInfo)
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