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


typealias ShouldAddGreenBorder = (value: Bool?) -> ()


class TREventTableCellView: UITableViewCell {

    @IBOutlet weak var eventIcon            :UIImageView?
    @IBOutlet weak var eventTitle           :UILabel?
    @IBOutlet weak var activityLight        :UILabel?
    @IBOutlet weak var eventPlayersName     :UILabel!
    @IBOutlet weak var playerImageOne       :UIImageView!
    @IBOutlet weak var playerImageTwo       :UIImageView!
    @IBOutlet weak var playerCountImage     :UIImageView!
    @IBOutlet weak var playerCountLabel     :UILabel!
    @IBOutlet weak var joinEventButton      :EventButton!
    @IBOutlet weak var leaveEventButton     :EventButton!
    
    
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
            if let _ = eventInfo.eventCreator?.playerPsnID {
                let finalString = NSMutableAttributedString(string: "Created by " + (eventInfo.eventCreator?.playerPsnID!)!)
                finalString.appendAttributedString(extraPlayersRequiredCountStringNewAttributed)
                self.eventPlayersName.attributedText = finalString
            }
        } else {
            let playersNameString = "Created by " + (eventInfo.eventCreator?.playerUserName!)!
            self.eventPlayersName.text = playersNameString
        }
        
        // Set Event Icon Image
        let url = NSURL(string: (eventInfo.eventActivity?.activityIconImage)!)
        self.eventIcon!.sd_setImageWithURL(url)
        
        // Set Event Button Status
        self.eventButtonStatusForCurrentPlayer(eventInfo, button: self.joinEventButton, completion: {value in
            if value == true {
                // Adding Green Border Around an event which is FULL && READY
                self.contentView.layer.borderWidth = 1.0
                self.contentView.layer.borderColor = UIColor(red: 96/255, green: 184/255, blue: 0/255, alpha: 1).CGColor
            }
        })
    }
    
    func addRadiusToPlayerIconsForPlayersArray (eventInfo: TREventInfo) {
        
        let playerArray = eventInfo.eventPlayersArray
        
        for (index, player) in playerArray.enumerate() {
            switch index {
            case 0:
                let imageUrl = NSURL(string: player.playerImageUrl!)
                self.playerImageOne!.sd_setImageWithURL(imageUrl)
                TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.playerImageOne)
                
                break;
            case 1:
                self.playerImageTwo.hidden = false
                let imageUrl = NSURL(string: player.playerImageUrl!)
                self.playerImageTwo.sd_setImageWithURL(imageUrl)
                TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.playerImageTwo)
                
                break;
                
            case 2:
                self.playerCountImage.hidden = false
                if(eventInfo.eventMaxPlayers?.integerValue > 3) {
                    self.playerCountImage.image = nil
                    self.playerCountLabel.hidden = false
                    self.playerCountLabel?.text = "+" + String((playerArray.count - 2))
                    TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.playerCountImage)
                    
                } else {
                    self.playerCountLabel.hidden = true
                    let imageUrl = NSURL(string: player.playerImageUrl!)
                    self.playerCountImage.sd_setImageWithURL(imageUrl)
                    TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.playerCountImage)
                }
                
                break;
                
            default:
                break;
            }
        }
    }
        
    func eventButtonStatusForCurrentPlayer (event: TREventInfo, button: EventButton, completion: ShouldAddGreenBorder) {

        button.userInteractionEnabled = true
        
        if (event.eventCreator?.playerID == TRUserInfo.getUserID()) {
            button.setImage(UIImage(named: "btnOWNER"), forState: .Normal)
            button.userInteractionEnabled = false
            leaveEventButton.hidden = false
            
            return
        }
        
        if (event.eventStatus == EVENT_STATUS.FULL.rawValue) {
            if(TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event)) {
                button.setImage(UIImage(named: "btnREADY"), forState: .Normal)
                button.userInteractionEnabled = false
                leaveEventButton.hidden = false
//                completion(value: true)
            } else {
                button.setImage(UIImage(named: "btnFULL"), forState: .Normal)
                button.userInteractionEnabled = false
                leaveEventButton.hidden = true
            }
            
        } else if (event.eventStatus == EVENT_STATUS.NEW.rawValue) {
            if (TRApplicationManager.sharedInstance.isCurrentPlayerCreatorOfTheEvent(event)) {
                button.setImage(UIImage(named: "btnGOING"), forState: .Normal)
                button.userInteractionEnabled = false
                leaveEventButton.hidden = false
            } else {
                button.setImage(UIImage(named: "btnJOIN"), forState: .Normal)
                leaveEventButton.hidden = true
            }
            
        } else if (event.eventStatus == EVENT_STATUS.OPEN.rawValue) {
            if (TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event)) {
                button.setImage(UIImage(named: "btnGOING"), forState: .Normal)
                button.userInteractionEnabled = false
                leaveEventButton.hidden = false
            } else {
                button.setImage(UIImage(named: "btnJOIN"), forState: .Normal)
                leaveEventButton.hidden = true
            }
        } else {
            //CAN_JOIN
            if (TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event)) {
                button.setImage(UIImage(named: "btnGOING"), forState: .Normal)
                button.userInteractionEnabled = false
                leaveEventButton.hidden = false
            } else {
                button.setImage(UIImage(named: "btnJOIN"), forState: .Normal)
                leaveEventButton.hidden = true
            }
        }
    }
}



