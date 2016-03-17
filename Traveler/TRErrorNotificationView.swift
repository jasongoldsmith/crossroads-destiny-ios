//
//  TRErrorNotificationView.swift
//  Traveler
//
//  Created by Ashutosh on 3/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRErrorNotificationView: UIView {
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin]
    }
    
    @IBAction func closeErrorView (sender: AnyObject) {
        self.removeFromSuperview()
    }
}