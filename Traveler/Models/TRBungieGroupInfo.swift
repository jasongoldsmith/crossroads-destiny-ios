//
//  TRBungieGroup.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRBungieGroupInfo {
    
    var groupId         : String?
    var avatarPath      : String?
    var groupName       : String?
    var memberCount     : integer_t?
    var clanEnabled     : Bool?
    var eventCount      : integer_t?

    
    func parseAndCreateObj (swiftyJson: JSON) {
        self.groupId = swiftyJson["groupId"].string
        self.avatarPath = swiftyJson["avatarPath"].string
        self.groupName = swiftyJson["groupName"].string
        self.memberCount = swiftyJson["memberCount"].int32
        self.clanEnabled = swiftyJson["clanEnabled"].boolValue
        self.eventCount = swiftyJson["eventCount"].int32
    }
}

