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
 
    func createAnEvent (completion: TRValueCallBack) {
        
        let createEventUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_EventCreationUrl
        
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
                            TRApplicationManager.sharedInstance.eventsInfo.append(createdEvent)

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