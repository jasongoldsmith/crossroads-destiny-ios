//
//  TRgetActivityList.swift
//  Traveler
//
//  Created by Ashutosh on 3/1/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TRgetActivityList: TRRequest {
    
    func getActivityList (completion: TRValueCallBack) {
        
        let activityListUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_ActivityListUrl
        
        let request = TRRequest()
        request.requestURL = activityListUrl
        request.URLMethod = .GET
        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                TRApplicationManager.sharedInstance.errorNotificationView.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            // Remove all pre-fetched and saved activities
            TRApplicationManager.sharedInstance.activityList.removeAll()
            
            for activity in swiftyJsonVar.arrayValue {
                
                let activityInfo = TRActivityInfo()
                
                activityInfo.activityID         = activity["_id"].stringValue
                activityInfo.activitySubType    = activity["aSubType"].stringValue
                activityInfo.activityCheckPoint = activity["aCheckpoint"].stringValue
                activityInfo.activityType       = activity["aType"].stringValue
                activityInfo.activityDificulty  = activity["aDifficulty"].stringValue
                activityInfo.activityLight      = activity["aLight"].number
                activityInfo.activityMaxPlayers = activity["maxPlayers"].number
                activityInfo.activityMinPlayers = activity["minPlayers"].number
                activityInfo.activityIconImage  = activity["aIconUrl"].stringValue
                
                TRApplicationManager.sharedInstance.activityList.append(activityInfo)
            }
            
            completion(didSucceed: true )
        }
    }
}

