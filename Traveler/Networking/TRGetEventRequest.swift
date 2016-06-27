//
//  TRGetEventRequest.swift
//  Traveler
//
//  Created by Ashutosh on 6/24/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRGetEventRequest: TRRequest {

    func getEventByID (eventID: String, completion: TREventObjCallBack) {
        let eventInfoULR = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GET_EVENT
        var params = [String: AnyObject]()
        params["id"] = eventID
        
        
        let request = TRRequest()
        request.params = params
        request.requestURL = eventInfoULR
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(event: nil)
                
                return
            }
            
            let eventObj = TREventInfo().parseCreateEventInfoObject(swiftyJsonVar)
            completion(event: eventObj)
        }
    }
    
}