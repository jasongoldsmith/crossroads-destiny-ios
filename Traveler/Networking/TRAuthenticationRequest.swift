//
//  TRAuthenticationRequest.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/22/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class TRAuthenticationRequest: TRRequest {
    
    func registerTRUserWith(userData: TRUserInfo?,completion:TRValueCallBack)  {
        
        let registerUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_RegisterUrl
        
        if (userData == nil) {
            completion(didSucceed: false)
            return
        }
        
        var params = [String: AnyObject]()
        if userData?.userName?.characters.isEmpty == false {
            params["userName"] = userData?.userName
        }
        if userData?.password?.characters.isEmpty == false {
            params["passWord"] = userData?.password
        }
        if userData?.psnID?.characters.isEmpty == false {
            params["psnId"] = userData?.psnID
        }

        
        TRApplicationManager.sharedInstance.activityIndicator.startActivityIndicator(false, activityTopConstraintValue: nil)
        
        request(self.URLMethod!, registerUserUrl, parameters:params)
            .responseJSON { response in
                
                //Stop Indicator
                TRApplicationManager.sharedInstance.activityIndicator.stopActivityIndicator()

                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar.isEmpty {
                            completion(didSucceed: false )
                        }
                            
                        else if swiftyJsonVar["responseType"].string == "ERR" {
                            completion(didSucceed: false )
                            
                        } else
                        {
                            let userData = TRUserInfo()
                            userData.userName       = swiftyJsonVar["value"]["userName"].string
                            userData.userID         = swiftyJsonVar["value"]["_id"].string
                            userData.psnID          = swiftyJsonVar["value"]["psnID"].string
                            userData.userImageURL   = swiftyJsonVar["value"]["imageUrl"].string

                            TRUserInfo.saveUserData(userData)
                            completion(didSucceed: true )
                        }
                    } else {
                        completion(didSucceed: false )
                    }
                }
                else
                {
                    completion(didSucceed: false )
                }
        }
    }
    
    
    func loginTRUserWith(userData: TRUserInfo?,completion:TRValueCallBack)  {
        
        if (userData == nil) {
            completion(didSucceed: false)
            return
        }
        
        let registerUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LoginUrl
        var params = [String: AnyObject]()
        if userData?.userName?.characters.isEmpty == false {
            params["userName"] = userData?.userName
        }
        if userData?.password?.characters.isEmpty == false {
            params["passWord"] = userData?.password
        }
        
        TRApplicationManager.sharedInstance.activityIndicator.startActivityIndicator(false, activityTopConstraintValue: nil)
        
        request(.POST, registerUserUrl,parameters:params)
            .responseJSON { response in
                
                //Stop Indicator
                TRApplicationManager.sharedInstance.activityIndicator.stopActivityIndicator()

                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar.isEmpty {
                            completion(didSucceed: false)
                        } else if swiftyJsonVar["responseType"].string == "ERR" {
                            completion(didSucceed: false )
                        }
                        else {
                            let userData = TRUserInfo()
                            userData.userName       = swiftyJsonVar["value"]["userName"].string
                            userData.userID         = swiftyJsonVar["value"]["_id"].string
                            userData.psnID          = swiftyJsonVar["value"]["psnID"].string
                            userData.userImageURL   = swiftyJsonVar["value"]["imageUrl"].string
                            userData.userClanID     = swiftyJsonVar["value"]["clanId"].string
                            
                            TRUserInfo.saveUserData(userData)
                            completion(didSucceed: true )
                        }
                    } else {
                        completion(didSucceed: false )
                    }
                } else {
                    completion(didSucceed: false )
                }
        }
    }
    
    func logoutTRUser(completion:(Bool?) -> ())  {
        
        if (TRUserInfo.isUserLoggedIn() == false) {
            completion(false )
        }
        
        let registerUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LogoutUrl
        TRApplicationManager.sharedInstance.activityIndicator.startActivityIndicator(false, activityTopConstraintValue: nil)

        request(.POST, registerUserUrl,parameters:["userName":TRUserInfo.getUserName()!])
            .responseJSON { response in
                
                //Stop Indicator
                TRApplicationManager.sharedInstance.activityIndicator.stopActivityIndicator()
                
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar.isEmpty {
                            completion(false )
                        } else if swiftyJsonVar["responseType"].string == "ERR" {
                            completion(false )
                        } else {
                            let userData = TRUserInfo()
                            userData.userName = swiftyJsonVar["value"]["userName"].string
                            userData.password = swiftyJsonVar["value"]["passWord"].string
                            userData.psnID          = swiftyJsonVar["value"]["psnID"].string
                            userData.userImageURL   = swiftyJsonVar["value"]["imageUrl"].string
                            userData.userClanID     = swiftyJsonVar["value"]["clanId"].string

                            TRUserInfo.saveUserData(userData)
                            completion(true )
                        }
                    } else {
                        completion( false )
                    }
                } else {
                    completion( false )
                }
            }
    }
}
