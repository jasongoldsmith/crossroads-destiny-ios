//
//  TRGetEventsList.swift
//  Traveler
//
//  Created by Ashutosh on 2/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TRGetEventsList: TRRequest {
    
    func getEventsList (completion: TRValueCallBack) {
        
        let eventListingUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_EventListUrl
        
        request(.GET, eventListingUrl, parameters:nil)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar.isEmpty {
                            completion(value: false )
                    }
                    else if swiftyJsonVar["responseType"].string == "ERR" {
                        completion(value: false )
                    }
                    else {
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