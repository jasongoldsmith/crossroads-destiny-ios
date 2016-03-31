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
    
    override func prepareForReuse() {
        self.playerAvatorImageView?.image = nil
        self.playerNameLable?.text = nil
        self.chatButton?.hidden = false
        self.chatButton?.buttonPlayerInfo = nil
    }
    
    func updateCellViewWithEvent (playerInfo: TRPlayerInfo, eventInfo: TREventInfo) {
        
        self.playerNameLable?.text = playerInfo.playerPsnID
        self.chatButton?.buttonPlayerInfo = playerInfo
        
        //Adding Image and Radius to Avatar
        let imageURL = NSURL(string: playerInfo.playerImageUrl!)
        if let _ = imageURL {
            self.playerAvatorImageView?.sd_setImageWithURL(imageURL)
            TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.playerAvatorImageView!)
        }

        if !TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(eventInfo) {
            self.chatButton?.hidden = true
        } else if playerInfo.playerID == TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()?.playerID {
            self.chatButton?.hidden = true
        } else if playerInfo.playerID != eventInfo.eventCreator?.playerID {
            self.chatButton?.hidden = true
        }
    }
}

