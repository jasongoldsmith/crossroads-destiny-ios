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

enum ServerResponseError {
    case NoValidData
    case ServerError(message: String)
    case NoError
}


class TRAuthenticationRequest: TRRequest {
    
    typealias TRAuthenticationCallback = (value: Bool?) -> ()
    //, error: ServerResponseError?) -> ()
    
    
    func registerTRUserWith(userData: TRUserInfo?,completion:TRAuthenticationCallback)  {
        
        if (userData == nil) {
            print("\(String(self))- TRUserInfo is nil")
            completion(value: false)   //,error: .NoValidData)
            return
            
        }
        
        let registerUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_RegisterUrl
        
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
        
        request(self.URLMethod!, registerUserUrl, parameters:params)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar.isEmpty {
                            completion(value: false ) //,error: .ServerError(message: "Return Data is empty"))
                        }
                            
                        else if swiftyJsonVar["responseType"].string == "ERR" {
                            
                            //   let errorMessage = swiftyJsonVar["message"]["message"].string
                            completion(value: false )  //,error: .ServerError(message: errorMessage!))
                            
                        }
                        else
                        {
                            
                            let userData = TRUserInfo()
                            userData.userName = swiftyJsonVar["value"]["userName"].string
                            userData.password = swiftyJsonVar["value"]["passWord"].string
                            // userData.psnID = swiftyJsonVar["value"]["psnId"].string
                            TRUserInfo.saveUserData(userData)
                            completion(value: true )  //,error: .None)
                        }
                        
                    }
                    else
                    {
                        completion(value: false ) // ,error: .ServerError(message: "Return Data is empty"))
                    }
                }
                else
                {
                    completion(value: false ) //,error: .ServerError(message: "Return Data Failed"))
                }
        }
    }
    
    
    func loginTRUserWith(userData: TRUserInfo?,completion:TRAuthenticationCallback)  {
        
        if (userData == nil) {
            print("\(String(self))- TRUserInfo is nil")
            completion(value: false)   //,error: .NoValidData)
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
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar.isEmpty {
                            completion(value: false ) //,error: .ServerError(message: "Return Data is empty"))
                        }
                            
                        else if swiftyJsonVar["responseType"].string == "ERR" {
                            
                            //   let errorMessage = swiftyJsonVar["message"]["message"].string
                            completion(value: false )  //,error: .ServerError(message: errorMessage!))
                            
                        }
                        else
                        {
                            
                            let userData = TRUserInfo()
                            userData.userName = swiftyJsonVar["value"]["userName"].string
                            userData.password = swiftyJsonVar["value"]["passWord"].string
                            // userData.psnID = swiftyJsonVar["value"]["psnId"].string
                            TRUserInfo.saveUserData(userData)
                            completion(value: true )  //,error: .None)
                        }
                        
                    }
                    else
                    {
                        completion(value: false ) // ,error: .ServerError(message: "Return Data is empty"))
                    }
                }
                else
                {
                    completion(value: false ) //,error: .ServerError(message: "Return Data Failed"))
                }
        }
    }
    
    func logoutTRUser(completion:(Bool?) -> ())  {
        
        if (TRUserInfo.isUserLoggedIn() == false) {
            print("\(String(self))- Userinfo is not present")
            completion(false )
        }
        
        
        let registerUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LogoutUrl
        request(.POST, registerUserUrl,parameters:["userName":TRUserInfo.getUserName()!])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if response.result.isSuccess {
                    
                    if let _ = response.result.value {
                        let swiftyJsonVar = JSON(response.result.value!)
                        if swiftyJsonVar.isEmpty {
                            completion(false ) //,error: .ServerError(message: "Return Data is empty"))
                        }
                            
                        else if swiftyJsonVar["responseType"].string == "ERR" {
                            
                            //   let errorMessage = swiftyJsonVar["message"]["message"].string
                            completion(false )  //,error: .ServerError(message: errorMessage!))
                            
                        }
                        else
                        {
                            
                            let userData = TRUserInfo()
                            userData.userName = swiftyJsonVar["value"]["userName"].string
                            userData.password = swiftyJsonVar["value"]["passWord"].string
                            // userData.psnID = swiftyJsonVar["value"]["psnId"].string
                            TRUserInfo.saveUserData(userData)
                            completion(true )  //,error: .None)
                        }
                        
                    }
                    else
                    {
                        completion( false ) // ,error: .ServerError(message: "Return Data is empty"))
                    }
                }
                else
                {
                    completion( false ) //,error: .ServerError(message: "Return Data Failed"))
                }
        }
        
    }
    
    
    
}
