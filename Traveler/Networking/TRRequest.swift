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
typealias TREventObjCallBackWithError = (error: String?, event: TREventInfo?) -> ()

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
    var viewHandlesError: Bool = false
    
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
        
        //Add System Info
        self.addSystemInformation()
        
        
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
                                
                                if self.viewHandlesError == false {
                                    TRApplicationManager.sharedInstance.addErrorSubViewWithMessage(message)
                                    completion(error: message, responseObject: nil)
                                } else {
                                    completion(error: message, responseObject: nil)
                                }
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
    
    func addSystemInformation () {
        
        if let _ = self.params {
        } else {
            self.params = [String: AnyObject]()
        }
        
        let systemVersion = UIDevice.currentDevice().systemVersion
        let deviceModel = UIDevice.currentDevice().model
        let devicetype = "iOS"
        let appversion = "\(NSBundle.mainBundle().releaseVersionNumber!) (\(NSBundle.mainBundle().buildVersionNumber!))"
        let manufacturer = "Apple"
        let branchSDKVersion = "0.12.5"
        let faceBookSDKVersion = "0.1.1"
        let fireBaseSDKVersion = "3.5.1"
        let mixPlanelSDKVersion = "1.0.0"
        let fabricSDK = "1.6.8"
        
        self.params?["x-osversion"] = systemVersion
        self.params?["x-devicetype"] = devicetype
        self.params?["x-devicemodel"] = deviceModel
        self.params?["x-appversion"] = appversion
        self.params?["x-fbooksdk"] = faceBookSDKVersion
        self.params?["x-fbasesdk"] = fireBaseSDKVersion
        self.params?["x-mpsdk"] = mixPlanelSDKVersion
        self.params?["x-branchsdk"] = branchSDKVersion
        self.params?["x-manufacturer"] = manufacturer
        self.params?["x-fabricSDK"] = fabricSDK
    }
}


