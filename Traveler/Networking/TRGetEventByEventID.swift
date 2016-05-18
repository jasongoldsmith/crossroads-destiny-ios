//
//  TRGetEventByEventID.swift
//  Traveler
//
//  Created by Ashutosh on 5/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//


class TRGetEventByEventID: TRRequest {

    func getEventByID(eventID: String, completion: TREventObjCallBack) {
        
        let resetPassword = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_FETCH_EVENT
        var params = [String: AnyObject]()
        params["id"] = eventID
        
        let request = TRRequest()
        request.params = params
        request.requestURL = resetPassword
        request.sendRequestWithCompletion { (error, responseObject) in
            if let _ = error {
                return
            }
            
            if responseObject != nil {
                // Creating Event Objects from Events List
                let eventInfo = TREventInfo().parseCreateEventInfoObject(responseObject)
                
                if let eventToUpdate = TRApplicationManager.sharedInstance.getEventById(eventInfo.eventID!) {
                    let eventIndex = TRApplicationManager.sharedInstance.eventsList.indexOf(eventToUpdate)
                    TRApplicationManager.sharedInstance.eventsList.removeAtIndex(eventIndex!)
                }
                
                TRApplicationManager.sharedInstance.eventsList.insert(eventInfo, atIndex: 0)
                completion(event: eventInfo)
            }
        }
    }
}
