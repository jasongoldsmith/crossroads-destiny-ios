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

    
    override func prepareForReuse() {
        self.groupAvator.image = nil
        self.groupName.text = nil
        self.memberCount?.text = nil
        self.clanEnabled?.text = nil
    }
    
    func updateCellViewWithGroup (groupInfo: TRBungieGroupInfo) {
        if let hasImage = groupInfo.avatarPath {
            let imageUrl = NSURL(string: hasImage)
            self.groupAvator?.sd_setImageWithURL(imageUrl)
        }
        
        self.groupName.text = groupInfo.groupName
        self.memberCount.text = groupInfo.memberCount?.description
        
        if groupInfo.clanEnabled?.boolValue == true {
            self.clanEnabled.text = "Clan Enabled"
        } else {
            self.clanEnabled.text = "Clan Disabled"
        }
    }
}

