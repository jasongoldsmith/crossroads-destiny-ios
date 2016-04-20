//
//  TRActivityInfo.swift
//  Traveler
//
//  Created by Ashutosh on 2/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRActivityInfo: NSObject {
    
    var activityID            : String?
    var activitySubType       : String?
    var activityLight         : NSNumber?
    var activityV             : String?
    var activityCheckPoint    : String?
    var activityType          : String?
    var activityDificulty     : String?
    var activityMaxPlayers    : NSNumber?
    var activityMinPlayers    : NSNumber?
    var activityIconImage     : String?
    var activityIsFeatured    : Bool?
    var activitylocation      : String?
    
    func parseAndCreateActivityObject (swiftyJson: JSON) -> TRActivityInfo {
        
        self.activityID         = swiftyJson["_id"].stringValue
        self.activitySubType    = swiftyJson["aSubType"].stringValue
        self.activityCheckPoint = swiftyJson["aCheckpoint"].stringValue
        self.activityType       = swiftyJson["aType"].stringValue
        self.activityDificulty  = swiftyJson["aDifficulty"].stringValue
        self.activityLight      = swiftyJson["aLight"].number
        self.activityMaxPlayers = swiftyJson["maxPlayers"].number
        self.activityMinPlayers = swiftyJson["minPlayers"].number
        self.activityIconImage  = swiftyJson["aIconUrl"].stringValue
        self.activityIsFeatured = swiftyJson["isFeatured"].boolValue
        self.activitylocation   = swiftyJson["location"].stringValue
        
        return self
    }
}