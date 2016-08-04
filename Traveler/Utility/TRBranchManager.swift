//
//  TRBranchManager.swift
//  Traveler
//
//  Created by Ashutosh on 7/13/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Branch

//typealias ErrorTypeCallBack = (errorType: Branch_Error?) -> ()

class TRBranchManager {
    
    let canonicalIdentifier = "canonicalIdentifier"
    var branchUniversalObject = BranchUniversalObject()
    let canonicalUrl = "https://dev.branch.io/getting-started/deep-link-routing/guide/ios/"
    let contentTitle = "contentTitle"
    let contentDescription = "My Content Description"
    let imageUrl = "https://pbs.twimg.com/profile_images/658759610220703744/IO1HUADP.png"
    let feature = "Sharing Feature"
    let channel = "Distribution Channel"
    let desktop_url = "http://branch.io"
    let ios_url = "http://crossrd.app.link/eQIMLli1Yu"
    let shareText = "Super amazing thing I want to share"
    let user_id1 = "abe@emailaddress.io"
    let user_id2 = "ben@emailaddress.io"
    let live_key = "key_live_ilh33QPvqAgDqnVVRh8iXcnnBBaLIp97"
    let test_key = "key_test_eipYWJLAEvhEqkSRNoZp2lmlvqmOIrkl"
    
    func createLinkWithBranch (eventInfo: TREventInfo, deepLinkType: String, callback: callbackWithUrl) {
        
        guard let eventID = eventInfo.eventID else {
            return
        }

        let extraPlayersRequiredCount = ((eventInfo.eventActivity?.activityMaxPlayers?.integerValue)! - (eventInfo.eventPlayersArray.count))
        let playerCount = String(extraPlayersRequiredCount)
        let console = TRUserInfo.getConsoleType()
        let activityName = eventInfo.eventActivity?.activityType!
        
        //Formatted Date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let eventDate = formatter.dateFromString(eventInfo.eventLaunchDate!)
        let formatedDate = eventDate!.toString(format: .Custom(trDateFormat()))

        // Group Name
        var groupName = ""
        if let currentGroupID = TRUserInfo.getUserClanID() {
            if let hasCurrentGroup = TRApplicationManager.sharedInstance.getCurrentGroup(currentGroupID) {
                groupName = hasCurrentGroup.groupName!
            }
        }
        
        var messageString = "\(console!): I need \(playerCount) more for \(activityName!) in the \(groupName) group on Crossroads"
        
        if eventInfo.isFutureEvent == true {
            messageString = "\(console!): I need \(playerCount) more for \(activityName!) on \(formatedDate) in the \(groupName) group on Crossroads"
        }
        
        if extraPlayersRequiredCount == 2 {
            if eventInfo.isFutureEvent == true {
                messageString = "Check out this \(activityName!) on \(formatedDate) in the \(groupName) group "
            } else {
                messageString = "Check out this \(activityName!) in the \(groupName) group "
            }
        }
    
        
        // Create Branch Object
        branchUniversalObject = BranchUniversalObject.init(canonicalIdentifier: canonicalIdentifier)
        branchUniversalObject.title = "Join My Fireteam"
        branchUniversalObject.contentDescription = messageString
        
        if let hasActivityCard = eventInfo.eventActivity?.activityID {
            let imageString = "http://w3.crossroadsapp.co/bungie/share/branch/v1/\(hasActivityCard)"
            branchUniversalObject.imageUrl  = imageString
        } else {
            branchUniversalObject.imageUrl  = "http://w3.crossroadsapp.co/bungie/share/branch/v1/default.png"
        }
        
        branchUniversalObject.addMetadataKey("eventId", value: eventID)
        branchUniversalObject.addMetadataKey("deepLinkType", value: deepLinkType)
        branchUniversalObject.addMetadataKey("activityName", value: eventInfo.eventActivity?.activitySubType)
        
        // Create Link
        let linkProperties = BranchLinkProperties()
        branchUniversalObject.getShortUrlWithLinkProperties(linkProperties) { (url, error) in
            if (error == nil) {
                print(url)
                callback(url, nil)
                
            } else {
                print(String(format: "Branch TestBed: %@", error))
            }
        }
    }
}

