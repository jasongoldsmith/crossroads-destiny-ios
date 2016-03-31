//
//  ImageHelper.swift
//  Traveler
//
//  Created by Ashutosh on 3/3/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {

    func roundImageView (imageView: UIImageView) {
        self.roundImageView(imageView, borderWidth: 0.5)
    }
    
    func roundImageView (imageView: UIImageView, borderWidth: CGFloat) {
        imageView.layer.borderWidth     = borderWidth
        imageView.layer.cornerRadius    = imageView.frame.size.width/2
        imageView.layer.borderColor     = UIColor.lightGrayColor().CGColor
        imageView.layer.masksToBounds   = true
    }

}