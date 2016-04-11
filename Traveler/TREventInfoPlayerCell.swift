//
//  TREventInfoPlayerCell.swift
//  Traveler
//
//  Created by Ashutosh on 3/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TREventInfoPlayerCell: UITableViewCell {
    
    @IBOutlet weak var playerAvatorImageView: UIImageView?
    @IBOutlet weak var playerNameLable: UILabel?
    @IBOutlet weak var chatButton: EventButton?
    @IBOutlet weak var leaveEventButton: EventButton?
    
    override func prepareForReuse() {
        self.playerAvatorImageView?.layer.borderWidth = 0.0
        self.playerAvatorImageView?.image = nil
        self.playerNameLable?.text = nil
        self.chatButton?.hidden = false
        self.chatButton?.buttonPlayerInfo = nil
        self.leaveEventButton?.buttonEventInfo = nil
    }
    
    func updateCellViewWithEvent (playerInfo: TRPlayerInfo, eventInfo: TREventInfo) {
        
        self.playerNameLable?.text = playerInfo.playerPsnID
        self.chatButton?.buttonPlayerInfo = playerInfo
        self.leaveEventButton?.buttonEventInfo = eventInfo
        
        //Adding Image and Radius to Avatar
        let imageURL = NSURL(string: playerInfo.playerImageUrl!)
        if let _ = imageURL {
            self.playerAvatorImageView?.sd_setImageWithURL(imageURL)
            TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.playerAvatorImageView!)
        }

        if !TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(eventInfo) {
            self.chatButton?.hidden = true
            return
        }
        
        // If current user is in the event, give an option to leave the event
        if TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(eventInfo) &&  playerInfo.playerID == TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()?.playerID {
            self.leaveEventButton?.hidden = false
            self.chatButton?.hidden = true
        }
        
        if playerInfo.playerID == eventInfo.eventCreator?.playerID {
            self.chatButton?.hidden = false
            return
        }
        
        if playerInfo.playerID != eventInfo.eventCreator?.playerID {
            self.chatButton?.hidden = true
        }
    }
}

