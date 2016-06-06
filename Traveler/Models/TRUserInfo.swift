//
//  TRUserInfo.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/21/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRUserInfo: NSObject {
    
    var userName        :String?
    var password        :String?
    var userID          :String?
    var userImageURL    :String?
    var userClanID      :String?
    var bungieMemberShipID: String?
    var consoles        :[TRConsoles] = []
    
    var psnID           :String? // Use "getConsoleID" insted of PSN_ID
    
    
    func parseUserResponse (responseObject: JSON) {
        self.userName       = responseObject["value"]["userName"].string
        self.userID         = responseObject["value"]["_id"].string
        self.userImageURL   = responseObject["value"]["imageUrl"].string
        self.userClanID     = responseObject["value"]["clanId"].string
        self.bungieMemberShipID = responseObject["value"]["bungieMemberShipId"].string
        
        let consoles = responseObject["value"]["consoles"].array
        for consoleObj in consoles! {
            let console = TRConsoles()
            console.consoleId = consoleObj["consoleId"].string
            console.consoleType = consoleObj["consoleType"].string
            console.verifyStatus = consoleObj["verifyStatus"].string
            
            TRUserInfo.saveConsolesObject(console)
        }
    }
    
    class func saveConsolesObject (consoleObj: TRConsoles) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(consoleObj.consoleId, forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID)
        userDefaults.setValue(consoleObj.consoleType  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE)
        userDefaults.setValue(consoleObj.verifyStatus  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED)
    }
    
    class func saveUserData (userData:TRUserInfo?) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(userData?.userName, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserName)
        userDefaults.setValue(userData?.userImageURL  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE)
        userDefaults.setValue(userData?.userClanID  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID)
        userDefaults.setValue(userData?.userID, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_UserID)
        userDefaults.setValue(userData?.bungieMemberShipID, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID)
        
        //userDefaults.setValue(userData?.psnID, forKey: K.UserDefaultKey.UserAccountInfo.TR_PsnId)
        userDefaults.synchronize()
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

    // Is Verified
    class func isUserVerified () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let verification = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED) as? String {
            return verification
        }

        return nil
    }

    
    // ************************************//
    // ************************************//
    // ************************************//
    // These are saved from Bungie User Authentication response. Used as params for SignUp flow. Singup response sends an array of Console (Array) Objects
    // whete this data is finally saved. A person can have multiple consoles, hence an array.
    
    
    //CONSOLE ID is the user's xbox gamertag or playstation ID
    class func saveConsoleID (bungieAccount: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(bungieAccount , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID)
        
        
        //Hardcoding it here, since user verification has begun
        userDefaults.setValue(ACCOUNT_VERIFICATION.USER_VER_INITIATED.rawValue, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED)
        
        userDefaults.synchronize()
    }
    
    class func getConsoleID() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) as? String
        }
        
        return nil
    }
    
    // BUNGIE MEMBER_SHIP ID
    class func saveBungieMemberShipId (memberShipID: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(memberShipID , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID)
        userDefaults.synchronize()
    }
    
    class func getBungieMembershipID () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID) as? String
        }
        
        return nil
    }
    
    // CONSOLE TYPE
    class func saveConsoleType (consoleType: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(consoleType , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE)
        userDefaults.synchronize()
    }
    
    class func getConsoleType () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) as? String
        }
        
        return nil
    }

    
    class func removeUserData () {
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
    }

}
