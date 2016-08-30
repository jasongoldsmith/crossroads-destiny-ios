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
        let finalString = urlString.stringByReplacingOccurrencesOfString("dlcsrd:/", withString: "")
        let parsedKeys = finalString.componentsSeparatedByString("/")
        var deepLinkDict = [String: String]()
        
        for (index, element) in parsedKeys.enumerate() {
            switch index {
            case 0:
                deepLinkDict["source"] = element
                break
            case 1:
                deepLinkDict["campaign"] = element
                break
            case 2:
                deepLinkDict["ad"] = element
                break
            case 3:
                deepLinkDict["creative"] = element
                break

            default:
                break
            }
        }
        
        self.parseDeepLinkDict(JSON(deepLinkDict))
    }

    
    func parseDeepLinkDict (linkJson: JSON) {
        
        self.deeplinkIsAd = linkJson["source"].boolValue
        self.deepSource = linkJson["campaign"].stringValue
        self.deepCampain = linkJson["ad"].stringValue
        self.deepAdType   = linkJson["creative"].stringValue
    }
    
    func createLinkInfoAndPassToBackEnd () -> Dictionary <String, AnyObject>? {
        
        var trackingDict = Dictionary<String, AnyObject> ()
        
        if let _ = self.deeplinkIsAd {
            trackingDict["source"] = self.deeplinkIsAd
        }

        if let _ = self.deepSource {
            trackingDict["campaign"] = self.deepSource
        }

        if let _ = self.deepCampain {
            trackingDict["ad"] = self.deepCampain
        }

        if let _ = self.deepAdType {
            trackingDict["creative"] = self.deepAdType
        }
        
        return trackingDict
        
    }
}