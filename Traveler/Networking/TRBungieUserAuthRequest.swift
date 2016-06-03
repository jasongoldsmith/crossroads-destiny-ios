//
//  TRBungieUserAuthRequest.swift
//  Traveler
//
//  Created by Ashutosh on 6/2/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRBungieUserAuthRequest: TRRequest {
    
    func verifyBungieUserName (consoleId: String, consoleType: String, completion: TRValueCallBack) {
        let bungieVerification = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_BUNGIE_USER_AUTH
        
        let request = TRRequest()
        
        var params = [String: AnyObject]()
        params["consoleId"] = consoleId
        params["consoleType"] = consoleType
        self.params = params
        request.requestURL = bungieVerification
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            completion(didSucceed: true )
        }
    }
}