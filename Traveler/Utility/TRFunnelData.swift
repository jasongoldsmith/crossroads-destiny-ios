//
//  TRFunnelData.swift
//  Traveler
//
//  Created by Ashutosh on 8/31/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import CoreTelephony
import Mixpanel

class TRFunnelData {
    
    static let telephonyInfo = CTTelephonyNetworkInfo()
    
    class func getData () -> Dictionary <String, AnyObject> {

        var p: Dictionary <String, AnyObject> = Dictionary()
        let branchSDKVersion = "0.12.6"
        let faceBookSDKVersion = "0.1.1"
        let fireBaseSDKVersion = "3.5.2"
        let fabricSDK = "1.6.8"
        let size = UIScreen.mainScreen().bounds.size
        let infoDict = NSBundle.mainBundle().infoDictionary
        if let infoDict = infoDict {
            p["$app_build_number"]     = infoDict["CFBundleVersion"]
            p["$app_version_string"]   = infoDict["CFBundleShortVersionString"]
        }
        p["$carrier"]           = self.telephonyInfo.subscriberCellularProvider?.carrierName
        p["mp_lib"]             = "swift"
        p["$lib_version"]       = self.libVersion()
        p["$manufacturer"]      = "Apple"
        p["$os"]                = UIDevice.currentDevice().systemName
        p["$os_version"]        = UIDevice.currentDevice().systemVersion
        p["$model"]             = self.deviceModel()
        p["$screen_height"]     = Int(size.height)
        p["$screen_width"]      = Int(size.width)
       
        if let infoDict = infoDict {
            p["$ios_app_version"] = infoDict["CFBundleVersion"]
            p["$ios_app_release"] = infoDict["CFBundleShortVersionString"]
        }
        p["$ios_device_model"]  = self.deviceModel()
        p["$ios_version"]       = UIDevice.currentDevice().systemVersion
        p["$ios_lib_version"]   = self.libVersion()
        p["x-fbooksdk"] = faceBookSDKVersion
        p["x-fbasesdk"] = fireBaseSDKVersion
        p["x-branchsdk"] = branchSDKVersion
        p["x-fabricsdk"] = fabricSDK
        
        let token = "23f27698695b0137adfef97f173b9f91"
        let mixpanel = Mixpanel.sharedInstanceWithToken(token)
        p["x-mixpanelid"] = mixpanel.distinctId
        
        return p
    }
    
    
    class func getCurrentRadio() -> String? {
        var radio = telephonyInfo.currentRadioAccessTechnology
        let prefix = "CTRadioAccessTechnology"
        if radio == nil {
            radio = "None"
        } else if radio!.hasPrefix(prefix) {
            radio = (radio! as NSString).substringFromIndex(prefix.characters.count)
        }
        return radio
    }
    
    class func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafeMutablePointer(&systemInfo.machine) {
            ptr in String.fromCString(UnsafePointer<CChar>(ptr))
        }
        if let model = modelCode {
            return model
        }
        return ""
    }
    
    class func libVersion() -> String? {
        return "3.0.2"
    }
    
}