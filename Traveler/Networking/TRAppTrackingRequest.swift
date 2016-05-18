//
//  TRAppTrackingRequest.swift
//  Traveler
//
//  Created by Ashutosh on 5/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRAppTrackingRequest: TRRequest {
    
    func sendApplicationPushNotiTracking (notiDict: NSDictionary, trackingType: APP_TRACKING_DATA_TYPE) {
       
        let appTrackingUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_APP_TRACKING
        var params = [String: AnyObject]()
        params["trackingData"] = notiDict
        params["trackingKey"] = trackingType.rawValue
        
        let request = TRRequest()
        request.params = params
        request.requestURL = appTrackingUrl
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                return
            }
        }
    }
}
