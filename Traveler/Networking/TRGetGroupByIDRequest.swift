//
//  TRGetGroupByIDRequest.swift
//  Traveler
//
//  Created by Ashutosh on 5/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRGetGroupByIDRequest: TRRequest {

    func getGroupByID (groupID: String, completion: TRValueCallBack) {
        
        let getGroupUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GET_GROUP_BY_ID + groupID

        let request = TRRequest()
        request.URLMethod = .GET
        request.requestURL = getGroupUrl
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            let bungieGroup = TRBungieGroupInfo()
            bungieGroup.groupId = swiftyJsonVar["groupId"].string
            bungieGroup.avatarPath = swiftyJsonVar["avatarPath"].string
            bungieGroup.groupName = swiftyJsonVar["groupName"].string
            bungieGroup.memberCount = swiftyJsonVar["memberCount"].int32
            bungieGroup.clanEnabled = swiftyJsonVar["clanEnabled"].boolValue
            
            TRApplicationManager.sharedInstance.currentBungieGroup = bungieGroup
            
            completion(didSucceed: true )
        }
    }
}
