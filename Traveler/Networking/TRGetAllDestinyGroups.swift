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

    func getAllGroups (completion: TRResponseCallBack) {
        let appGetGroups = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GET_GROUPS
        
        let request = TRRequest()
        request.params = params
        request.requestURL = appGetGroups
        request.URLMethod = .GET
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                return
            }
            
            completion(error: nil, responseObject: swiftyJsonVar)
        }
    }
}
