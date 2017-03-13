//
//  TRSendBungieAccountInfoRequest.swift
//  Traveler
//
//  Created by Ashutosh on 3/13/17.
//  Copyright © 2017 Forcecatalyst. All rights reserved.
//

import Foundation

class TRSendBungieAccountInfoRequest: TRRequest {
    
    func sendBungieAccountInfo (bungieResponse: AnyObject, completion: TRValueCallBack) {
        
        let requestURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_SEND_BUNGIE_USER
        
        let request = TRRequest()
        request.requestURL = requestURL
        request.showActivityIndicatorBgClear = true
        
        var params = [String: AnyObject]()
        params["bungieResponse"] = bungieResponse
        request.params = params
        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(didSucceed: false)
                return
            }
            
            completion(didSucceed: true)
        }
    }
}