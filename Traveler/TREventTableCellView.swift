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
        
        self.eventTitle?.text = eventInfo.eventActivity?.activitySubType
        self.activityLight?.text = "+" + (eventInfo.eventActivity?.activityLight?.stringValue)!
        
        var playersNameString = ""
        for players in eventInfo.eventPlayersArray {
            playersNameString += players.playerUserName!
        }
        
        self.eventPlayersName.text = playersNameString
    }
    
    func addRadiusToPlayerIconsForPlayersArray (playerArray: [TRPlayerInfo]) {
        
        for (index, _) in playerArray.enumerate() {
            switch index {
            case 0:
                self.addCostmeticsToPlayerAvatorIcon(self.playerImageOne)
                
                break;
            case 1:
                self.playerImageTwo.hidden = false
                self.addCostmeticsToPlayerAvatorIcon(self.playerImageTwo)
                
                break;
            default:
                self.playerCountImage.hidden = false
                self.playerCountLabel.hidden = false
                self.playerCountLabel?.text = "+" + String((playerArray.count - 2))
                self.addCostmeticsToPlayerAvatorIcon(self.playerCountImage)
                
                break;
            }
        }
    }
    
    func addCostmeticsToPlayerAvatorIcon (imageView: UIImageView) {
        imageView.layer.borderWidth = 1.0
        imageView.layer.cornerRadius = playerImageOne.frame.size.width/2
        imageView.layer.borderColor = UIColor.grayColor().CGColor
    }
}



