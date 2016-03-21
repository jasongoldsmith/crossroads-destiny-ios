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

    private let TIMER_INTERVAL: Double = 10
    private var timer: NSTimer = NSTimer()
    private var parentViewController: TRBaseViewController?
    
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

        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(TIMER_INTERVAL, target: self, selector: "animationTimer", userInfo: nil, repeats: false)
        self.activityIndicator?.startAnimating()
        
        if withClearBackGround {
            self.activityIndicatorBGImage.alpha = 0.0
        }
        
        if let newConstraint = activityTopConstraintValue {
            self.activityIndicatorTopConstraint?.constant = newConstraint
        }
    }
    
    func stopActivityIndicator () {
        
        self.timer.invalidate()
        self.activityIndicator?.stopAnimating()
        self.removeFromSuperview()
    }
    
    func animationTimer() {
        if ((self.activityIndicator?.isAnimating()) != nil) {

            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("No Server Response")
            
//            self.parentViewController?.displayAlertWithTitle("No Server Response", complete: { (complete) -> () in
//                self.stopActivityIndicator()
//                self.removeFromSuperview()
//                self.timer.invalidate()
//                self.parentViewController = nil
//            })
            
        }
    }
}