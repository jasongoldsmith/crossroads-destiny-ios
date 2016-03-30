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
    
    func updateCellViewWithEvent (playerInfo: TRPlayerInfo) {
        
        self.playerNameLable?.text = playerInfo.playerUserName
        
        //Adding Image and Radius to Avatar
        let imageURL = NSURL(string: playerInfo.playerImageUrl!)
        if let _ = imageURL {
            self.playerAvatorImageView?.sd_setImageWithURL(imageURL)
            TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.playerAvatorImageView!)
        }
    }
    
    @IBAction func chatButtonPressed (sender: AnyObject) {
        
    }
}