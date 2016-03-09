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
            completion(value: false)
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
        
        params["imageUrl"] = "http://images4.fanpop.com/image/photos/17800000/Benders-evolution-bender-17855605-650-487.jpg"
        
        request(self.URLMethod!, registerUserUrl, parameters:params)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar.isEmpty {
                            completion(value: false )
                        }
                            
                        else if swiftyJsonVar["responseType"].string == "ERR" {
                            completion(value: false )
                            
                        } else
                        {
                            let userData = TRUserInfo()
                            userData.userName       = swiftyJsonVar["value"]["userName"].string
                            userData.userID         = swiftyJsonVar["value"]["_id"].string
                            userData.psnID          = swiftyJsonVar["value"]["psnID"].string
                            userData.userImageURL   = swiftyJsonVar["value"]["imageUrl"].string
                            
                            TRUserInfo.saveUserData(userData)
                            completion(value: true )
                        }
                    } else {
                        completion(value: false )
                    }
                }
                else
                {
                    completion(value: false )
                }
        }
    }
    
    
    func loginTRUserWith(userData: TRUserInfo?,completion:TRValueCallBack)  {
        
        if (userData == nil) {
            completion(value: false)
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
        
        request(.POST, registerUserUrl,parameters:params)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar.isEmpty {
                            completion(value: false)
                        } else if swiftyJsonVar["responseType"].string == "ERR" {
                            completion(value: false )
                        }
                        else {
                            let userData = TRUserInfo()
                            userData.userName       = swiftyJsonVar["value"]["userName"].string
                            userData.userID         = swiftyJsonVar["value"]["_id"].string
                            userData.psnID          = swiftyJsonVar["value"]["psnID"].string
                            userData.userImageURL   = swiftyJsonVar["value"]["imageUrl"].string

                            TRUserInfo.saveUserData(userData)
                            completion(value: true )
                        }
                    } else {
                        completion(value: false )
                    }
                } else {
                    completion(value: false )
                }
        }
    }
    
    func logoutTRUser(completion:(Bool?) -> ())  {
        
        if (TRUserInfo.isUserLoggedIn() == false) {
            completion(false )
        }
        
        let registerUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LogoutUrl
        request(.POST, registerUserUrl,parameters:["userName":TRUserInfo.getUserName()!])
            .responseJSON { response in
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
