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
    var userClanID      :String?
    var psnVerified     :String?
    var xboxVerified    :String?
    
    static let User_Verified = "VERIFIED"
    
    class func saveUserData (userData:TRUserInfo?) -> Bool {
        
        if (userData == nil) {
            return false
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(userData?.userName, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserName)
        userDefaults.setValue(userData?.psnID, forKey: K.UserDefaultKey.UserAccountInfo.TR_PsnId)
        userDefaults.setValue(userData?.userID, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_UserID)
        userDefaults.setValue(userData?.userImageURL  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE)
        userDefaults.setValue(userData?.userClanID  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID)
        userDefaults.setValue(userData?.psnVerified  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_PSN_VERIFIED)
        userDefaults.setValue(userData?.xboxVerified  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_XBOX_VERIFIED)
        
        userDefaults.synchronize()
        
        self.isUserVerified()
        
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
    
    class func isUserVerified () -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if ((userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_PSN_VERIFIED) != nil) &&
            (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_PSN_VERIFIED) as? String == User_Verified)
            ||
            (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_XBOX_VERIFIED) != nil) &&
            (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_XBOX_VERIFIED) as? String == User_Verified))  {
            
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
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE) != nil) {
            let userImageUrl = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE) as! String
            
            return userImageUrl
        }
        
        let currentUser = TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()
        guard let currentUserImage = currentUser?.playerImageUrl else {
            return nil
        }
        
        return currentUserImage
    }

    class func getUserClanID () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID) != nil) {
            let userClanID = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID) as! String
            
            return userClanID
        }
        
        return nil
    }

    
    class func saveBungieAccount(bungieAccount: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(bungieAccount , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_VERIFIED)
        userDefaults.synchronize()
    }
    
    class func getbungieAccount() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_VERIFIED) as? String
    }
    
    class func removeUserData () {
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
    }

}
