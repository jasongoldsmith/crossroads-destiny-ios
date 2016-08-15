//
//  TRBorderLabelViewContainer.swift
//  Traveler
//
//  Created by Ashutosh on 8/14/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRBorderLabelViewContainer: UIView {
    
    @IBOutlet weak var labelOne: TRInsertLabel!
    @IBOutlet weak var labelTwo: TRInsertLabel!
    @IBOutlet weak var labelThree: TRInsertLabel!
    @IBOutlet weak var labelFour: TRInsertLabel!
 
    //Constraints
    @IBOutlet weak var labelOneLeftConstraint: NSLayoutConstraint!
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.labelOne.layer.borderColor = UIColor.whiteColor().CGColor
        self.labelTwo.layer.borderColor = UIColor.whiteColor().CGColor
        self.labelThree.layer.borderColor = UIColor.whiteColor().CGColor
        self.labelFour.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.labelOne.layer.borderWidth = 1.0
        self.labelTwo.layer.borderWidth = 1.0
        self.labelThree.layer.borderWidth = 1.0
        self.labelFour.layer.borderWidth = 1.0
    }
    
    func updateViewWithStringArray (stringArray: [String]) {
        
        let totalString = stringArray.count
        
        switch totalString {
        case 1:
            self.labelOne.text = stringArray.first?.uppercaseString
            self.labelOne.hidden = false
            let labelOneWidth = self.labelOne?.intrinsicContentSize().width
            
            self.updateConstraintsIfNeeded()
            break
        case 2:
            self.labelOne.text = stringArray.first?.uppercaseString
            self.labelTwo.text = stringArray[1].uppercaseString
            
            self.labelTwo.hidden = false
            self.labelOne.hidden = false
            break
        case 3:
            self.labelOne.text = stringArray.first?.uppercaseString
            self.labelTwo.text = stringArray[1].uppercaseString
            self.labelTwo.text = stringArray[2].uppercaseString
            
            self.labelOneLeftConstraint.constant = self.frame.width/2 - 3 * self.labelOne.frame.size.width
            
            self.labelThree.hidden = false
            self.labelTwo.hidden = false
            self.labelOne.hidden = false

            break
        case 4:
            break
        case 5:
            break
        default:
            break
        }
        
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 10, viewWidth!, self.frame.size.height)
    }
}