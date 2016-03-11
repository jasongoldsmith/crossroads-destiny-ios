//
//  TRActivityCheckPointPicker.swift
//  Traveler
//
//  Created by Ashutosh on 3/10/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


class TRActivityCheckPointPicker: UIView {
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var imageView: UIImageView!
    

    override func layoutSubviews() {

        self.pickerView!.layer.cornerRadius = 5.0
        self.pickerView!.backgroundColor = UIColor.whiteColor()
        self.pickerView!.layer.masksToBounds = true
    }

}

