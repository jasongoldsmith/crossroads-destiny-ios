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
    var activityLevel         : String?
    var activityAdCard        : TRAdCardInfo?
    
    var activityCheckPointOrder: NSNumber?
    var activityStory: String?
    var activityCardOrder: String?
    var activityTag: String?
    var activityImageBasePath: String?
    var activityImage: String?
    var activityIsActive: Bool?
    var activityBonus: [TRActivityBonus] = []
    var activityModifiers: [TRActivityModifiersInfo] = []
    
    
    func parseAndCreateActivityObject (swiftyJson: JSON) -> TRActivityInfo {
        
        self.activityID         = swiftyJson["_id"].stringValue
        self.activitySubType    = swiftyJson["aSubType"].stringValue
        self.activityCheckPoint = swiftyJson["aCheckpoint"].stringValue
        self.activityType       = swiftyJson["aType"].stringValue
        self.activityDificulty  = swiftyJson["aDifficulty"].stringValue
        self.activityLight      = swiftyJson["aLight"].numberValue
        self.activityMaxPlayers = swiftyJson["maxPlayers"].numberValue
        self.activityMinPlayers = swiftyJson["minPlayers"].numberValue
        self.activityIconImage  = swiftyJson["aIconUrl"].stringValue
        self.activityIsFeatured = swiftyJson["isFeatured"].boolValue
        self.activitylocation   = swiftyJson["location"].stringValue
        self.activityLevel      = swiftyJson["aLevel"].stringValue
        self.activityCheckPointOrder = swiftyJson["aCheckpointOrder"].numberValue
        self.activityStory = swiftyJson["aStory"].stringValue
        self.activityCardOrder = swiftyJson["aCardOrder"].stringValue
        self.activityTag = swiftyJson["tag"].stringValue
        self.activityImageBasePath = swiftyJson["aImage"][["aImageBaseUrl"]].stringValue
        self.activityImage = self.activityImageBasePath! + swiftyJson["aImage"][["aImageImagePath"]].stringValue
        self.activityIsActive = swiftyJson["isActive"].boolValue
        
        
        if let card = swiftyJson["adCard"].dictionary {
            let acitivityCard = TRAdCardInfo()
            acitivityCard.parseAndCreateActivityObject(JSON(card))
            
            self.activityAdCard = acitivityCard
        }
        
        
        if let bonus = swiftyJson["aBonus"].dictionary {
            let activityBonus = TRActivityBonus()
            activityBonus.parseActivityBonus(JSON(bonus))
            
            self.activityBonus.append(activityBonus)
        }
        
        if let modifiers = swiftyJson["aModifiers"].dictionary {
            let activityModifier = TRActivityModifiersInfo()
            activityModifier.parseActivityModifiers(JSON(modifiers))
            
            self.activityModifiers.append(activityModifier)
        }
        
        return self
    }
}