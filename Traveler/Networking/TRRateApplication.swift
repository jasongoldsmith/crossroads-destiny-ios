//
//  TRRateApplication.swift
//  Traveler
//
//  Created by Ashutosh on 1/12/17.
//  Copyright © 2017 Forcecatalyst. All rights reserved.
//

import Foundation

class TRRateApplication: TRRequest {
    
    func updateRateApplication(ratingStatus: String, completion: TRValueCallBack) {
        
        let requestURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_APP_REVIEW
        
        let request = TRRequest()
        request.requestURL = requestURL
        
        var params = [String: AnyObject]()
        params["reviewPromptCardStatus"] = ratingStatus
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