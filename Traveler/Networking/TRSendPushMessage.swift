//
//  TRSendPushMessage.swift
//  Traveler
//
//  Created by Ashutosh on 3/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRSendPushMessage: TRRequest {
    
    func sendPushMessageTo (userId: String, eventId: String, messageString: String, completion: TRValueCallBack) {
        
        let pushMessage = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_SEND_PUSH_MESSAGE
        var params = [String: AnyObject]()
        params["id"]        = userId
        params["eId"]       = eventId
        params["message"]   = messageString
        
        let request = TRRequest()
        request.params = params
        request.requestURL = pushMessage
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.errorNotificationView.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            completion(didSucceed: true )
        }
    }
    
    func sendPushMessageToAll(eventId: String, messageString: String, completion: TRValueCallBack) {
        
        let eventInfo = TRApplicationManager.sharedInstance.getEventById(eventId)
        
        if let _ = eventInfo {
            for players in eventInfo!.eventPlayersArray {
                
                if players.playerID != TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()?.playerID {
                    let pushMessage = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_SEND_PUSH_MESSAGE
                    var params = [String: AnyObject]()
                    params["id"]        = players.playerID
                    params["eId"]       = eventInfo!.eventID
                    params["message"]   = messageString
                    
                    let request = TRRequest()
                    request.params = params
                    request.requestURL = pushMessage
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
        }
    }
}