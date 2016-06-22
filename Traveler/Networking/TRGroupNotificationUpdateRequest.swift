//
//  TRGroupNotificationUpdateRequest.swift
//  Traveler
//
//  Created by Ashutosh on 6/22/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRGroupNotificationUpdateRequest: TRRequest {
    
    func updateUserGroupNotification (groupID: String, completion: TRValueCallBack) {
        let updateGroupNoti = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GROUP_NOTI_VALUE
        var params = [String: AnyObject]()
        params["id"] = TRUserInfo.getUserID()
        
        let request = TRRequest()
        request.params = params
        request.requestURL = updateGroupNoti
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            //Remove all pre-saved groups
            TRApplicationManager.sharedInstance.bungieGroups.removeAll()
            
            //Add newly fetched groups
            for group in swiftyJsonVar.arrayValue {
                let bungieGroup = TRBungieGroupInfo()
                bungieGroup.parseAndCreateObj(group)
                TRApplicationManager.sharedInstance.bungieGroups.append(bungieGroup)
            }
            
            completion(didSucceed: true )
        }
    }
}