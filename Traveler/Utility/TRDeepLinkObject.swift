//
//  TRDeepLinkObject.swift
//  Traveler
//
//  Created by Ashutosh on 8/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON


class TRDeepLinkObject: NSObject {
    
    var deepLink: String? //Link
    var deepSource: String? //FB, Branch
    
    //Advertisement
    var deeplinkIsAd: Bool? //Ad
    var deepCampain: String? //Campian Type
    var deepAdType: String?
    var deepCreative: String?
    
    init(link: NSURL) {
        
        super.init()
        
        let urlString = link.absoluteString
        
        let parsedKeys = urlString.componentsSeparatedByString("/")
        var keyValueStringArray: [String] = []
        for keys in parsedKeys {
            if !keys.isEmpty {
                keyValueStringArray.append(keys)
            }
        }
        
        var deepLinkDict = [String: String]()
        for keys in keyValueStringArray {
            let valueComponent = keys.componentsSeparatedByString("-")
            let key = valueComponent.first?.stringByRemovingPercentEncoding
            let value = valueComponent.last?.stringByRemovingPercentEncoding
            
            print("Key: \(key) Value: \(value)")
            deepLinkDict[key!] = value
        }
        
        
        self.parseDeepLinkDict(JSON(deepLinkDict))
    }

    
    func parseDeepLinkDict (linkJson: JSON) {
        
        self.deeplinkIsAd = linkJson["isAd"].boolValue
        self.deepSource = linkJson["sourceInfo"].stringValue
        self.deepCampain = linkJson["campaignInfo"].stringValue
        self.deepAdType   = linkJson["adInfo"].stringValue
        self.deepCreative = linkJson["creativeInfo"].stringValue
    }
    
    func createLinkInfoAndPassToBackEnd () -> Dictionary <String, AnyObject>? {
        
        var trackingDict = Dictionary<String, AnyObject> ()
        
        if let _ = self.deeplinkIsAd {
            trackingDict["isAd"] = self.deeplinkIsAd
        }

        if let _ = self.deepSource {
            trackingDict["sourceInfo"] = self.deepSource
        }

        if let _ = self.deepCampain {
            trackingDict["campaignInfo"] = self.deepCampain
        }

        if let _ = self.deepAdType {
            trackingDict["adInfo"] = self.deepAdType
        }

        if let _ = self.deepCreative {
            trackingDict["creativeInfo"] = self.deepCreative
        }

        
        return trackingDict
        
    }
}