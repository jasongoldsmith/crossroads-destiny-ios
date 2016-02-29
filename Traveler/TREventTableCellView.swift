//
//  TREventTableCellView.swift
//  Traveler
//
//  Created by Ashutosh on 2/28/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TREventTableCellView: UITableViewCell {

    @IBOutlet weak var eventIcon: UIImageView?
    @IBOutlet weak var eventTitle: UILabel?
    
    func updateCellViewWithEvent (eventInfo: TREventInfo) {
        eventTitle?.text = eventInfo.eventActivity?.activitySubType
        
    }
}