//
//  TRDeviceTokenRequest.swift
//  Traveler
//
//  Created by Ashutosh on 3/11/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TRDeviceTokenRequest: TRRequest {
    
    func sendDeviceToken (deviceToken: String, completion: TRValueCallBack) {
        
        let registerDevice = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_REGISTER_DEVICE
        var params         = [String: AnyObject]()
        params["deviceToken"]      = deviceToken
        
        
        request(self.URLMethod!, registerDevice, parameters:params)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar.isEmpty {
                            completion(value: false )
                        }
                        else if swiftyJsonVar["responseType"].string == "ERR" {
                            completion(value: false )
                        } else {
                            print("Token Response: \(swiftyJsonVar)")
                            completion(value: true )
                        }
                    } else {
                        completion(value: false )
                    }
                } else {
                    completion(value: false )
                }
            }
        }
}

