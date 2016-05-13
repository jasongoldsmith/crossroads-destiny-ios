//
//  TRForgotPasswordRequest.swift
//  Traveler
//
//  Created by Ashutosh on 5/13/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRForgotPasswordRequest: TRRequest {

    func resetUserPassword(userPsnID: String, completion: TRValueCallBack) {
        
        let resetPassword = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_FORGOT_PASSWORD
        var params = [String: AnyObject]()
        params["psnId"] = userPsnID
        
        let request = TRRequest()
        request.params = params
        request.requestURL = resetPassword
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
