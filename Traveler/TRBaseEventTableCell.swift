//
//  TRBaseEventTableCell.swift
//  Traveler
//
//  Created by Ashutosh on 4/21/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRBaseEventTableCell: UITableViewCell {
    
    override func prepareForReuse() {
        
        self.playerImageOne.image = nil
        self.playerImageTwo.image = nil
        self.playerCountLabel.text = nil
        self.playerCountImage.image = nil
        self.playerImageOne.hidden = true
        self.playerImageTwo.hidden = true
        self.playerCountLabel.hidden = true
        self.playerCountImage.hidden = true
        self.eventTimeLabel?.hidden = true
        self.activityCheckPointLabel?.text = nil
        self.activityCheckPointLabel?.hidden = true
    }
    
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
    @IBOutlet weak var activityCheckPointLabel : UILabel?
    @IBOutlet weak var eventTimeLabel       :UILabel?
    
    func updateCellViewWithEvent (eventInfo: TREventInfo) {
        
        //Adding Radius to
        self.addRadiusToPlayerIconsForPlayersArray(eventInfo)
        
        self.eventTitle?.text = eventInfo.eventActivity?.activitySubType
        
        if let _ = eventInfo.eventActivity?.activityLight?.intValue where eventInfo.eventActivity?.activityLight?.intValue > 0 {
            self.activityLight?.text = "+" + (eventInfo.eventActivity?.activityLight?.stringValue)!
            self.activityLight?.hidden = false
        } else {
            self.activityLight?.hidden = true
        }
        
        
        // Set  Event Player Names
        if (eventInfo.eventPlayersArray.count < eventInfo.eventActivity?.activityMaxPlayers?.integerValue) {
            let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)]
            let extraPlayersRequiredCount = ((eventInfo.eventActivity?.activityMaxPlayers?.integerValue)! - eventInfo.eventPlayersArray.count)
            let extraPlayersRequiredCountString = String(extraPlayersRequiredCount)
            let extraPlayersRequiredCountStringNew = " LF" + "\(extraPlayersRequiredCountString)M"
            
            // Attributed Strings
            let extraPlayersRequiredCountStringNewAttributed = NSAttributedString(string: extraPlayersRequiredCountStringNew, attributes: stringColorAttribute)
            if let _ = eventInfo.eventCreator?.playerPsnID {
                let finalString = NSMutableAttributedString(string: (eventInfo.eventCreator?.playerPsnID!)!)
                finalString.appendAttributedString(extraPlayersRequiredCountStringNewAttributed)
                self.eventPlayersName.attributedText = finalString
            }
        } else {
            let playersNameString = (eventInfo.eventCreator?.playerPsnID!)!
            self.eventPlayersName.text = playersNameString
        }
        
        // Set Event Icon Image
        if let imageURLString = eventInfo.eventActivity?.activityIconImage {
            let url = NSURL(string: imageURLString)
            self.eventIcon!.sd_setImageWithURL(url)
        }
        
        // Set Event Button Status
        self.eventButtonStatusForCurrentPlayer(eventInfo, button: self.joinEventButton)
        
        
        if let hasLaunchDate = eventInfo.eventLaunchDate {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let eventDate = formatter.dateFromString(hasLaunchDate)
            self.eventTimeLabel?.text = eventDate!.toString()
        }
        
        self.activityCheckPointLabel?.hidden = false
        self.activityCheckPointLabel?.text = eventInfo.eventActivity?.activityCheckPoint
    }
    
    func addRadiusToPlayerIconsForPlayersArray (eventInfo: TREventInfo) {
        
        let playerArray = eventInfo.eventPlayersArray
        
        for (index, player) in playerArray.enumerate() {
            switch index {
            case 0:
                
                self.playerImageOne.hidden = false
                
                if let imageURLString = player.playerImageUrl {
                    let url = NSURL(string: imageURLString)
                    self.playerImageOne!.sd_setImageWithURL(url)
                    self.playerImageOne?.roundRectView()
                }
                
                break;
            case 1:
                
                self.playerImageTwo.hidden = false
                
                if let imageURLString = player.playerImageUrl {
                    let url = NSURL(string: imageURLString)
                    self.playerImageTwo!.sd_setImageWithURL(url)
                    self.playerImageTwo?.roundRectView()
                }
                
                break;
                
            case 2:
                
                self.playerCountImage.hidden = false
                if(eventInfo.eventMaxPlayers?.integerValue > 3) {
                    self.playerCountImage.image = nil
                    self.playerCountLabel.hidden = false
                    self.playerCountLabel?.text = "+" + String((playerArray.count - 2))
                    self.playerCountImage?.roundRectView()
                    
                } else {
                    self.playerCountLabel.hidden = true
                    
                    if let imageURLString = player.playerImageUrl {
                        let url = NSURL(string: imageURLString)
                        self.playerCountImage!.sd_setImageWithURL(url)
                        self.playerCountImage?.roundRectView()
                    }
                }
                
                break;
                
            default:
                break;
            }
        }
    }
    
    func eventButtonStatusForCurrentPlayer (event: TREventInfo, button: EventButton) {
        
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
