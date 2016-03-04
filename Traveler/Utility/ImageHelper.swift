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
        imageView.layer.borderWidth     = 1.0
        imageView.layer.cornerRadius    = imageView.frame.size.width/2
        imageView.layer.borderColor     = UIColor.grayColor().CGColor
        imageView.layer.masksToBounds   = true
    }
}