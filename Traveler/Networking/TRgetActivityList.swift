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
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            // Remove all pre-fetched and saved activities
            TRApplicationManager.sharedInstance.activityList.removeAll()
            
            for activity in swiftyJsonVar.arrayValue {
                
                let activityInfo = TRActivityInfo().parseAndCreateActivityObject(activity)
                TRApplicationManager.sharedInstance.activityList.append(activityInfo)
            }
            
            completion(didSucceed: true )
        }
    }
}

