//
//  TRRequest.swift
//  Traveler
//
//  Created by Ashutosh on 2/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias TRRequestClosure = (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void
typealias TRValueCallBack = (didSucceed: Bool?) -> ()
typealias TRResponseCallBack = (error: String?, responseObject: JSON) -> ()

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
    var showActivityIndicator: Bool = true
    var showActivityIndicatorBgClear: Bool = false

    
    init() {
        self.shouldDrop = false
        self.URLMethod = .POST
        self.encodingType = .JSON
    }
    
    func sendRequestWithCompletion (completion: TRResponseCallBack) {
        
        //Start Activity Indicator
        if self.showActivityIndicator == true {
            TRApplicationManager.sharedInstance.activityIndicator.startActivityIndicator(self.showActivityIndicatorBgClear, activityTopConstraintValue: nil)
        }
        
        
        TRApplicationManager.sharedInstance.alamoFireManager!.request(self.URLMethod!, self.requestURL!, parameters:self.params)
            .responseJSON { response in
                
                // Stop Activity Indicator
                if self.showActivityIndicator == true {
                    TRApplicationManager.sharedInstance.activityIndicator.stopActivityIndicator()
                }
                
                switch response.result {
                case .Failure(let _):
                    TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("SERVER ERROR")
                case .Success( _):
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        
                        if swiftyJsonVar.isEmpty {
                            //false
                        } else if swiftyJsonVar["responseType"].string == "ERR" {
                            //false
                        } else {
                            //True
                            completion(error: nil, responseObject: (swiftyJsonVar))
                        }
                    }
                }
        }
    }
}


