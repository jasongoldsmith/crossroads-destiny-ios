//
//  TRPushNotificationView.swift
//  Traveler
//
//  Created by Ashutosh on 3/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRPushNotificationView: UIView {
    
    
    @IBOutlet weak var eventStatusLabel: UILabel!
    @IBOutlet weak var eventStatusDescription: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func closeErrorView (sender: AnyObject) {
        self.removeFromSuperview()
    }

}