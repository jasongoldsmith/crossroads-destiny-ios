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
        
        request(.POST, leaveEventtUrl, parameters:params)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        
                        if swiftyJsonVar.isEmpty {
                            completion(value: false )
                        } else if swiftyJsonVar["responseType"].string == "ERR" {
                            completion(value: false )
                        } else {
                            
                            if let _ = swiftyJsonVar["_id"].string {
                                // Creating Event Objects from Events List
                                let existingEvent = TRApplicationManager.sharedInstance.getEventById(swiftyJsonVar["_id"].string!)
                                
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
                                completion(value: true )
                            } else {
                                completion(value: false)
                            }
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
