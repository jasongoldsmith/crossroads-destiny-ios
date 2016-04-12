//
//  TRUserInfo.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/21/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRUserInfo: NSObject {
    
    var userName        :String?
    var password        :String?
    var psnID           :String?
    var userID          :String?
    var userImageURL    :String?
    
    class func saveUserData (userData:TRUserInfo?) -> Bool {
        
        if (userData == nil) {
            return false
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(userData?.userName, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserName)
        userDefaults.setValue(userData?.psnID, forKey: K.UserDefaultKey.UserAccountInfo.TR_PsnId)
        userDefaults.setValue(userData?.userID, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_UserID)
        userDefaults.setValue(userData?.userImageURL  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE)
        
        userDefaults.synchronize()
        
        return false
    }
    
    class func isCurrentUserEventCreator (event: TREventInfo) -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserID)?.string == event.eventCreator?.playerID)  {
            return true
        }
        
        return false
    }
    
    class func isUserLoggedIn () -> Bool {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserName) != nil) &&
           (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserPwd) != nil)  {
            
            return true
        }
        
        return false
    }
    
    class func getUserName() -> String? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserName) != nil) {
                let userName = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserName) as! String
                return userName
        }
        return nil
    }

    class func getUserID() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
            if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserID) != nil) {
            let userID = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserID) as! String
                
            return userID
        }
        
        return nil
    }

    class func getUserImageString() -> String? {
        
        let currentUser = TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()
        guard let currentUserImage = currentUser?.playerImageUrl else {
            return nil
        }
        
        return currentUserImage
    }

    
    class func removeUserData () {
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
    }

}
