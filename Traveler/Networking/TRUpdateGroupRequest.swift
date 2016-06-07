//
//  TRUpdateGroupRequest.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRUpdateGroupRequest: TRRequest {
    
    func updateUserGroup (groupID: String, completion: TRValueCallBack) {
        let updateGroupUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_UPDATE_GROUPS
        var params = [String: AnyObject]()
        params["id"] = TRUserInfo.getUserID()
        params["clanId"] = groupID
        
        let request = TRRequest()
        request.params = params
        request.requestURL = updateGroupUrl
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            let userData = TRUserInfo()
            userData.parseUserResponse(swiftyJsonVar)
            
            TRUserInfo.saveUserData(userData)

            completion(didSucceed: true )
        }
    }
}
