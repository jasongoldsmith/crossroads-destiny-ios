//
//  TRUserInfo.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/21/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRUserInfo: NSObject {
    
    var userName: String?
    var password: String?
    var psnID: String?
    
    class func saveUserData (userData:TRUserInfo?) -> Bool {
        
        if (userData == nil) {
            return false
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(userData?.userName, forKey: "TR_UserName")
        userDefaults.setValue(userData?.password, forKey: "TR_UserPwd")
        userDefaults.setValue(userData?.psnID, forKey: "TR_PsnId")
        userDefaults.synchronize()
        return false
        
    }
    
    class func isUserLoggedIn () -> Bool {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("TR_UserName") != nil) &&
           (userDefaults.objectForKey("TR_UserPwd") != nil)  {
            
            return true
        }
        return false
    }
    
    class func getUserName() -> String? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey("TR_UserName") != nil) {
                let userName = userDefaults.objectForKey("TR_UserName") as! String
                return userName
        }
        return nil
    }

    
    class func removeUserData () {
        
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
        
    }

}
