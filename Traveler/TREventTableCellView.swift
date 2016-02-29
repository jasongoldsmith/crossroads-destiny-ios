//
//  TREventTableCellView.swift
//  Traveler
//
//  Created by Ashutosh on 2/28/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


class TREventTableCellView: UITableViewCell {

    @IBOutlet weak var eventIcon:           UIImageView?
    @IBOutlet weak var eventTitle:          UILabel?
    @IBOutlet weak var activityLight:       UILabel?
    @IBOutlet weak var eventPlayersName:    UILabel!
    @IBOutlet weak var playerImageOne:      UIImageView!
    @IBOutlet weak var playerImageTwo:      UIImageView!
    @IBOutlet weak var playerCountImage:    UIImageView!
    @IBOutlet weak var playerCountLabel:    UILabel!
    @IBOutlet weak var joinEventButton:     JoinEventButton!
    
    func updateCellViewWithEvent (eventInfo: TREventInfo) {
        
        //Adding Radius to
        self.addRadiusToPlayerIconsForPlayersArray(eventInfo.eventPlayersArray)
        
        eventTitle?.text = eventInfo.eventActivity?.activitySubType
        activityLight?.text = "+" + (eventInfo.eventActivity?.activityLight?.stringValue)!
        
        var playersNameString = ""
        for players in eventInfo.eventPlayersArray {
            playersNameString += players.playerUserName!
        }
        
        eventPlayersName.text = playersNameString
    }
    
    func addRadiusToPlayerIconsForPlayersArray (playerArray: [TRPlayerInfo]) {
        playerImageOne.layer.cornerRadius = playerImageOne.frame.size.width/2
        playerImageTwo.layer.cornerRadius = playerImageTwo.frame.size.width/2
        playerCountImage?.layer.cornerRadius = playerCountImage.frame.size.width/2
        
        if playerArray.count > 2 {
            playerCountImage.hidden = false
            playerCountLabel.hidden = false
            
            playerCountLabel?.text = "+" + String((playerArray.count - 2))
        }
    }
}



