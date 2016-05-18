//
//  TRRequest.swift
//  Traveler
//
//  Created by Ashutosh on 2/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias TRRequestClosure = (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void
typealias TRValueCallBack = (didSucceed: Bool?) -> ()
typealias TRResponseCallBack = (error: String?, responseObject: JSON) -> ()
typealias TREventObjCallBack = (event: TREventInfo?) -> ()

enum ServerResponseError {
    case NoValidData
    case ServerError(message: String)
    case NoError
}

class TRRequest {
    
    var shouldDrop: Bool?
    var params:[String: AnyObject]?
    var URLMethod: Alamofire.Method?
    var encodingType: ParameterEncoding?
    var requestHandler: TRRequestClosure?
    var requestURL: String?
    
    // Activity Indicator
    var showActivityIndicator: Bool = true
    var showActivityIndicatorBgClear: Bool = false
    var activityIndicatorTopConstraint: CGFloat = 281.0
    
    init() {
        self.shouldDrop = false
        self.URLMethod = .POST
        self.encodingType = .JSON
    }
        
    func sendRequestWithCompletion (completion: TRResponseCallBack) {
        
        //Start Activity Indicator
        if self.showActivityIndicator == true {
            TRApplicationManager.sharedInstance.activityIndicator.startActivityIndicator(self.showActivityIndicatorBgClear, activityTopConstraintValue: self.activityIndicatorTopConstraint)
        }
        
        
        TRApplicationManager.sharedInstance.alamoFireManager!.request(self.URLMethod!, self.requestURL!, parameters:self.params)
            .responseJSON { response in
                
                // Stop Activity Indicator
                if self.showActivityIndicator == true {
                    TRApplicationManager.sharedInstance.activityIndicator.stopActivityIndicator()
                }
                
                switch response.result {
                case .Failure( _):
                    TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Server request failed. Please wait a few seconds and refresh.")
                    break
                case .Success( _):
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        
                        if swiftyJsonVar["responseType"].string == "ERR" {
                            if let message = swiftyJsonVar["error"].string {
                                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage(message)
                            } else {
                                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Undefined server error. Please wait a few seconds and refresh.")
                            }
                            
                        } else {
                            completion(error: nil, responseObject: (swiftyJsonVar))
                        }
                    }
                }
        }
    }
}


