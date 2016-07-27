//
//  TRGetEventsList.swift
//  Traveler
//
//  Created by Ashutosh on 2/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

class TRGetEventsList: TRRequest {
    
    func getEventsListWithClearActivityBackGround (showActivity: Bool, clearBG: Bool, indicatorTopConstraint: CGFloat?, completion: TRValueCallBack) {
        
        let eventListingUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_EventListUrl
        
        let request = TRRequest()
        request.requestURL = eventListingUrl
        request.URLMethod = .GET
        request.showActivityIndicatorBgClear = clearBG
        request.showActivityIndicator = showActivity
        
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
            TRApplicationManager.sharedInstance.eventsListActivity.removeAll()
            
            for events in swiftyJsonVar["currentEvents"].arrayValue {
                let eventInfo = TREventInfo().parseCreateEventInfoObject(events)
                TRApplicationManager.sharedInstance.eventsList.append(eventInfo)
            }

            for events in swiftyJsonVar["futureEvents"].arrayValue {
                let eventInfo = TREventInfo().parseCreateEventInfoObject(events)
                TRApplicationManager.sharedInstance.eventsList.append(eventInfo)
            }

            for events in swiftyJsonVar["adActivities"].arrayValue {
                let activityInfo = TRActivityInfo().parseAndCreateActivityObject(events)
                TRApplicationManager.sharedInstance.eventsListActivity.append(activityInfo)
            }

            
            completion(didSucceed: true)
        }
    }
}