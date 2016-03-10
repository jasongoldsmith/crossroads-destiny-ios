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
        params["creator"] = TRUserInfo().userID
        params["players"] = [activity.activityID!]
        
        request(.GET, createEventUrl, parameters:self.params)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        
                        if swiftyJsonVar.isEmpty {
                            completion(value: false )
                        } else if swiftyJsonVar["responseType"].string == "ERR" {
                            completion(value: false )
                        } else {
                            
                            let createdEvent = TREventInfo()
                            
                            //Adding it to "eventsInfo"
                            TRApplicationManager.sharedInstance.eventsList.append(createdEvent)

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