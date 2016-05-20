//
//  TRGetAllDestinyGroups.swift
//  Traveler
//
//  Created by Ashutosh on 5/18/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import Alamofire

class TRGetAllDestinyGroups: TRRequest {

    func getAllGroups (completion: TRValueCallBack) {
        let appGetGroups = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GET_GROUPS
        
        let request = TRRequest()
        request.params = params
        request.requestURL = appGetGroups
        request.URLMethod = .GET
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(didSucceed: false)
            }
            
            for group in swiftyJsonVar.arrayValue {
                
                let bungieGroup = TRBungieGroupInfo()
                bungieGroup.groupId = group["groupId"].string
                bungieGroup.avatarPath = group["avatarPath"].string
                bungieGroup.groupName = group["groupName"].string
                bungieGroup.memberCount = group["memberCount"].int32
                bungieGroup.clanEnabled = group["clanEnabled"].boolValue
                
                TRApplicationManager.sharedInstance.bungieGroups.append(bungieGroup)
            }
            
            completion(didSucceed: true)
        }
    }
}
