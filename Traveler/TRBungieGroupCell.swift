//
//  TRBungieGroupCell.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRBungieGroupCell: UITableViewCell {
    
    @IBOutlet weak var groupAvator: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var memberCount: UILabel!
    @IBOutlet weak var clanEnabled: UILabel!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var overlayImageView: UIImageView!
    
    override func prepareForReuse() {
        self.groupAvator.image = nil
        self.groupName.text = nil
        self.memberCount?.text = nil
        self.clanEnabled?.text = nil
        self.contentView.alpha = 1
        self.overlayImageView.hidden = true
        self.contentView.userInteractionEnabled = true
    }
    
    func updateCellViewWithGroup (groupInfo: TRBungieGroupInfo) {
        if let hasImage = groupInfo.avatarPath {
            let imageUrl = NSURL(string: hasImage)
            self.groupAvator?.sd_setImageWithURL(imageUrl)
        }
        
        self.groupName.text = groupInfo.groupName
        if let hasMembers = groupInfo.memberCount {
            self.memberCount.text =  hasMembers.description + " Members"
        }
        
        if let eventCount = groupInfo.eventCount where eventCount > 0 {
            
            if eventCount > 1 {
                self.clanEnabled.text = eventCount.description + " Events"
            } else {
                self.clanEnabled.text = eventCount.description + " Event"
            }
        } else {
            self.clanEnabled.text = "0 Events"
        }
        
    }
}

