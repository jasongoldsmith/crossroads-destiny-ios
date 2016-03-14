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
        imageView.layer.borderWidth     = 0.5
        imageView.layer.cornerRadius    = imageView.frame.size.width/2
//        imageView.layer.borderColor     = UIColor(red: 44/255, green: 53/255, blue: 59/255, alpha: 1).CGColor
        imageView.layer.borderColor     = UIColor.lightGrayColor().CGColor
        imageView.layer.masksToBounds   = true
    }
}