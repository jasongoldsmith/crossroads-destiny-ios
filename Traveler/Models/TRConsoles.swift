//
//  TRConsoles.swift
//  Traveler
//
//  Created by Ashutosh on 6/3/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRConsoles {
    var consoleId: String?
    var consoleType: String?
    var verifyStatus: String?
    
    func saveConsolesObject (consoleObj: TRConsoles) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(consoleObj.consoleId, forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID)
        userDefaults.setValue(consoleObj.consoleType  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE)
        userDefaults.setValue(consoleObj.verifyStatus  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED)
    }
    
    class func getConsoleID () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) as? String
        }
        
        return nil
    }
    
    class func getConsoleType () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) as? String
        }
        
        return nil
    }

    class func getConsoleVerifyStatus () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED) as? String
        }
        
        return nil
    }
}

