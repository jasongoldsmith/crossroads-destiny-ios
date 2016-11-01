//
//  TRBungieLoginValidation.swift
//  Traveler
//
//  Created by Ashutosh on 10/28/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


@objc protocol TRBungieLoginValidationProtocol {
    optional func userObjResponseReceived(shouldDismiss: Bool)
}

class TRBungieLoginValidation {
    
    var bungieID: String?
    var bungieCookies: [NSHTTPCookie]? = []
    var alamoFireManager : Alamofire.Manager?
    
    
    func shouldShowLoginSceen (completion: TRSignInCallBack, clearBackGroundRequest: Bool) {
        
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
        if let _ = cookies {
            for cookie in cookies! {
                if cookie.name == "bungleatk" || cookie.name == "bungledid" {
                    self.bungieCookies?.append(cookie)
                } else if cookie.name == "bungled" {
                    self.bungieID = cookie.value
                    self.bungieCookies?.append(cookie)
                }
            }
        }
        
        self.getUserFromTravelerBackEndWithSuccess({ (showLoginScreen, error) in
                completion(showLoginScreen: showLoginScreen, error: error)
            }, clearBackGroundRequest: true)
    }
    
    func getUserFromTravelerBackEndWithSuccess (completion: TRSignInCallBack, clearBackGroundRequest: Bool) {
        var p: Dictionary <String, AnyObject> = Dictionary()
        p["x-api-key"] = "f091c8d36c3c4a17b559c21cd489bec0" as AnyObject?
        p["x-csrf"] = self.bungieID as AnyObject?
        p["cookie"] = self.bungieCookies as AnyObject?
        
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = p
        self.alamoFireManager = Alamofire.Manager(configuration: configuration)
        self.alamoFireManager!.request(.GET, NSURL(string: "https://www.bungie.net/Platform/User/GetBungieNetUser")!, parameters: nil)
            .responseJSON { response in
                
                if let responseValue = response.result.value {
                    
                    if responseValue["Message"]!!.description == "Please sign-in to continue." {
                        completion(showLoginScreen: true, error: nil)
                        return
                    }
                    
                    _ = TRFetchBungieUser().getBungieUserWith(response.result.value!, clearBackGroundRequest: clearBackGroundRequest, completion: { (error, responseObject) in
                        
                        if let  _ = error {
                            return
                        }
                        
                        let userData = TRUserInfo()
                        userData.parseUserResponse(responseObject)
                        
                        for console in userData.consoles {
                            if console.isPrimary == true {
                                TRUserInfo.saveConsolesObject(console)
                            }
                        }
                        
                        TRUserInfo.saveUserData(userData)
                        NSNotificationCenter.defaultCenter().postNotificationName(K.NOTIFICATION_TYPE.USER_DATA_RECEIVED_CLOSE_WEBVIEW, object: nil)
                        
                        completion(showLoginScreen: false, error: nil)
                    })
                }
        }
    }
}