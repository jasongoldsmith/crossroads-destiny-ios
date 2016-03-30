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
    @IBOutlet weak var chatButton: UIButton?
    
    override func prepareForReuse() {
        self.playerAvatorImageView?.image = nil
        self.playerNameLable?.text = nil
        self.chatButton?.hidden = false
    }
    
    func updateCellViewWithEvent (playerInfo: TRPlayerInfo, eventInfo: TREventInfo) {
        
        self.playerNameLable?.text = playerInfo.playerPsnID
        
        //Adding Image and Radius to Avatar
        let imageURL = NSURL(string: playerInfo.playerImageUrl!)
        if let _ = imageURL {
            self.playerAvatorImageView?.sd_setImageWithURL(imageURL)
            TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.playerAvatorImageView!)
        }
        
        // I can not send message to myself, so hide chat button
        if playerInfo.playerID == TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()?.playerID {
            self.chatButton?.hidden = true
        }
        
        // A user can only send chat message to the owner, so hide chat for anyone who is not the owner
        if playerInfo.playerID != eventInfo.eventCreator?.playerID {
            self.chatButton?.hidden = true
        }
    }
}

