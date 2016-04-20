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
    
    func getEventsListWithClearActivityBackGround (clearBG: Bool, indicatorTopConstraint: CGFloat?, completion: TRValueCallBack) {
        
        let eventListingUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_EventListUrl
        
        let request = TRRequest()
        request.requestURL = eventListingUrl
        request.URLMethod = .GET
        request.showActivityIndicatorBgClear = clearBG
        if let topConstraint = indicatorTopConstraint {
            request.activityIndicatorTopConstraint = topConstraint
        }

        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }

            //Clear the array before fetting
            TRApplicationManager.sharedInstance.eventsList.removeAll()
            
            for events in swiftyJsonVar.arrayValue {
                let eventInfo = TREventInfo().parseCreateEventInfoObject(events)
                TRApplicationManager.sharedInstance.eventsList.append(eventInfo)
            }
            
            completion(didSucceed: true)
        }
    }
}