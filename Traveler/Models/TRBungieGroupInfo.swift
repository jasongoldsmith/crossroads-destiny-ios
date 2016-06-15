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
        self.groupId = swiftyJson["groupId"].stringValue
        self.avatarPath = swiftyJson["avatarPath"].stringValue
        self.groupName = swiftyJson["groupName"].stringValue
        self.memberCount = swiftyJson["memberCount"].int32Value
        self.clanEnabled = swiftyJson["clanEnabled"].boolValue
        self.eventCount = swiftyJson["eventCount"].int32Value
    }
}

