//
//  TRErrorNotificationView.swift
//  Traveler
//
//  Created by Ashutosh on 3/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import pop


class TRErrorNotificationView: UIView {
    
    @IBOutlet weak var errorMessage: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin]
    }
    
    @IBAction func closeErrorView (sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    func addErrorSubViewWithMessage (errorMessage: String) {
        
        if self.superview != nil {
            return
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let window = appDelegate.window
        window?.addSubview(self)
        
        let yAxisDistance:CGFloat = -50
        let xAxiDistance:CGFloat  = 0
        self.frame = CGRectMake(xAxiDistance, yAxisDistance, window!.frame.width, self.frame.height)
        self.errorMessage.text = errorMessage
        
        let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
        popAnimation.toValue = 50
        self.layer.pop_addAnimation(popAnimation, forKey: "slideIn")
        
        delay(3.0) { () -> () in
            let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
            popAnimation.toValue = -20
            popAnimation.completionBlock =  {(animation, finished) in
                self.removeFromSuperview()
            }
            self.layer.pop_addAnimation(popAnimation, forKey: "slideOut")
        }
    }
}


