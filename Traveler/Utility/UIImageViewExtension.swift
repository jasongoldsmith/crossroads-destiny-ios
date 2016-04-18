//
//  UIImageViewExtension.swift
//  Traveler
//
//  Created by Ashutosh on 4/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func roundImageView () {
        self.roundImageView(0.5)
    }
    
    func roundImageView (borderWidth: CGFloat) {
        self.layer.borderWidth     = borderWidth
        self.layer.cornerRadius    = self.frame.size.width/2
        self.layer.borderColor     = UIColor.lightGrayColor().CGColor
        self.layer.masksToBounds   = true
    }
    
}

