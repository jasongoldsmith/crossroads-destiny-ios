//
//  TRActivityIndicatorView.swift
//  Traveler
//
//  Created by Ashutosh on 3/14/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


class TRActivityIndicatorView: UIView {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorBGImage: UIImageView!
    @IBOutlet var activityIndicatorTopConstraint: NSLayoutConstraint!
    
    
    func startActivityIndicator (withClearBackGround: Bool, activityTopConstraintValue: CGFloat?) {
        
        self.activityIndicatorBGImage.alpha = 0.7
        self.activityIndicatorTopConstraint?.constant = 281.0
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let window = appDelegate.window
        self.frame = (window?.bounds)!
        window?.addSubview(self)
        
        if withClearBackGround {
            self.activityIndicatorBGImage.alpha = 0.0
        }
        
        if let newConstraint = activityTopConstraintValue {
            self.activityIndicatorTopConstraint?.constant = newConstraint
        }
    }
    
    func stopActivityIndicator () {
        
        self.activityIndicator?.stopAnimating()
        self.removeFromSuperview()
    }
}