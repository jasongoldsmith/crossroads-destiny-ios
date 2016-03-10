//
//  TRActivitySelectionCell.swift
//  Traveler
//
//  Created by Ashutosh on 3/9/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

private let CORNER_RADIUS: CGFloat = 2

class TRActivitySelectionCell: UITableViewCell {
 
    
    @IBOutlet weak var activityIconImage: UIImageView!
    @IBOutlet weak var activityInfoLabel: UILabel!
    
    
    func updateCell (activity: TRActivityInfo) {
        
        let imageUrl = NSURL(string: activity.activityIconImage!)
        
        var labelSting = activity.activitySubType! + " - " + activity.activityDificulty! + " "
        if let light = activity.activityLight?.integerValue where light > 0 {
            labelSting = labelSting + (activity.activityLight?.stringValue)! + " Light"
        }
        
        self.activityIconImage.sd_setImageWithURL(imageUrl)
        self.activityInfoLabel.text = labelSting
        
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.shadowColor  = UIColor.grayColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0, 2)
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false;
        self.clipsToBounds = false;
    }
}