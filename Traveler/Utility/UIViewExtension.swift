//
//  UIViewExtension.swift
//  Traveler
//
//  Created by Ashutosh on 4/18/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
 
    func roundRectView () {
        self.roundRectView(0.5)
    }
    
    func roundRectView (borderWidth: CGFloat) {
        self.layer.borderWidth     = borderWidth
        self.layer.cornerRadius    = self.frame.size.width/2
        self.layer.borderColor     = UIColor.whiteColor().CGColor
        self.layer.masksToBounds   = true
    }
    
}