//
//  TREventInfo.swift
//  Traveler
//
//  Created by Ashutosh on 2/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TREventInfo: NSObject {

    var eventID                 : String?
    var eventStatus             : String?
    var eventUpdatedDate        : String?
    var eventV                  : String?
    var eventMaxPlayers         : NSNumber?
    var eventMinPlayer          : NSNumber?
    var eventCreatedDate        : String?
    var eventLaunchDate         : String?
    var eventActivity           : TRActivityInfo?
    var eventCreator            : TRCreatorInfo?
    var eventPlayersArray       : [TRPlayerInfo] = []
}

