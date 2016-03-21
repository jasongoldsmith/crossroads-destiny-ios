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
        var params = [String: AnyObject]()
        params["deviceToken"]      = deviceToken
        
        let request = TRRequest()
        request.params = params
        request.requestURL = registerDevice
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.errorNotificationView.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }

            completion(didSucceed: true )
        }
    }
}

        
//        request(self.URLMethod!, registerDevice, parameters:params)
//            .responseJSON { response in
//                if response.result.isSuccess {
//                    
//                    if let _ = response.result.value {
//                        let swiftyJsonVar = JSON(response.result.value!)
//                        if swiftyJsonVar.isEmpty {
//                            completion(didSucceed: false )
//                        }
//                        else if swiftyJsonVar["responseType"].string == "ERR" {
//                            completion(didSucceed: false )
//                        } else {
//                            print("Token Response: \(swiftyJsonVar)")
//                            completion(didSucceed: true )
//                        }
//                    } else {
//                        completion(didSucceed: false )
//                    }
//                } else {
//                    completion(didSucceed: false )
//                }
//            }
//        }
//}

