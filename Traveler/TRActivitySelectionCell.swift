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

        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.8
        self.clipsToBounds = false
        
        let shadowFrame: CGRect = (self.bounds)
        let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
        self.layer.shadowPath = shadowPath

    }
}