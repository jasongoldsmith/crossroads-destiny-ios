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
        self.roundRectView(0.5, borderColor: UIColor.whiteColor())
    }
    
    func roundRectView (borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth     = borderWidth
        self.layer.cornerRadius    = self.frame.size.width/2
        self.layer.borderColor     = borderColor.CGColor
        self.layer.masksToBounds   = true
    }
    
    func round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
        return mask
    }
    
}