//
//  TREventTableCellView.swift
//  Traveler
//
//  Created by Ashutosh on 2/28/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


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
        self.addRadiusToPlayerIconsForPlayersArray(eventInfo)
        
        self.eventTitle?.text = eventInfo.eventActivity?.activitySubType
        self.activityLight?.text = "+" + (eventInfo.eventActivity?.activityLight?.stringValue)!
        
        // Set  Event Player Names
        if (eventInfo.eventPlayersArray.count < eventInfo.eventMaxPlayers?.integerValue) {
            
            
            let stringColorAttribute = [NSForegroundColorAttributeName: UIColor.yellowColor()]
            let extraPlayersRequiredCount = ((eventInfo.eventMaxPlayers?.integerValue)! - eventInfo.eventPlayersArray.count)
            let extraPlayersRequiredCountString = String(extraPlayersRequiredCount)
            let extraPlayersRequiredCountStringNew = " LF" + "\(extraPlayersRequiredCountString)M"
            
            // Attributed Strings
            let extraPlayersRequiredCountStringNewAttributed = NSAttributedString(string: extraPlayersRequiredCountStringNew, attributes: stringColorAttribute)
            let finalString = NSMutableAttributedString(string: "Created by" + (eventInfo.eventCreator?.playerUserName!)!)
            finalString.appendAttributedString(extraPlayersRequiredCountStringNewAttributed)
            
            self.eventPlayersName.attributedText = finalString
            
        } else {
            let playersNameString = "Created by" + (eventInfo.eventCreator?.playerUserName!)!
            self.eventPlayersName.text = playersNameString
        }
        
        // Set Event Icon Image
        let url = NSURL(string: (eventInfo.eventActivity?.activityIconImage)!)
        self.eventIcon!.sd_setImageWithURL(url)
        
        // Set Event Button Status
        self.eventButtonStatusForCurrentPlayer(eventInfo, button: self.joinEventButton)
    }
    
    func addRadiusToPlayerIconsForPlayersArray (eventInfo: TREventInfo) {
        
        let playerArray = eventInfo.eventPlayersArray
        
        for (index, _) in playerArray.enumerate() {
            switch index {
            case 0:
                self.addCostmeticsToPlayerAvatorIcon(self.playerImageOne)
//                self.playerImageOne.sd_setImageWithURL(NSURL(string: player)))
                
                break;
            case 1:
                self.playerImageTwo.hidden = false
                self.addCostmeticsToPlayerAvatorIcon(self.playerImageTwo)
//                self.playerImageOne.sd_setImageWithURL(NSURL(string: player)))
                
                break;
            default:
                
                if(eventInfo.eventMaxPlayers?.integerValue > 3) {
                    self.playerCountImage.hidden = false
                    self.playerCountLabel.hidden = false
                    self.playerCountLabel?.text = "+" + String((playerArray.count - 2))
                    self.addCostmeticsToPlayerAvatorIcon(self.playerCountImage)
//                    self.playerImageOne.sd_setImageWithURL(NSURL(string: player)))

                } else {
                    self.playerCountImage.hidden = false
                    self.playerCountLabel.hidden = true
                    self.addCostmeticsToPlayerAvatorIcon(self.playerCountImage)
//                    self.playerImageOne.sd_setImageWithURL(NSURL(string: player)))
                }
                
                break;
            }
        }
    }
    
    func addCostmeticsToPlayerAvatorIcon (imageView: UIImageView) {
        imageView.layer.borderWidth = 1.0
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    func eventButtonStatusForCurrentPlayer (event: TREventInfo, button: JoinEventButton) {

        if (event.eventStatus == EVENT_STATUS.FULL.rawValue) {
            
        } else if (event.eventStatus == EVENT_STATUS.NEW.rawValue) {
            
        } else if (event.eventStatus == EVENT_STATUS.OPEN.rawValue) {
            
        } else {
            
        }
        
    }
}



