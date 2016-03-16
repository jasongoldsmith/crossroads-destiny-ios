//
//  TRActivityIndicatorView.swift
//  Traveler
//
//  Created by Ashutosh on 3/14/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


class ActivityIndicatorView: UIView {

    private let TIMER_INTERVAL: Double = 10
    private var timer: NSTimer = NSTimer()
    private var parentViewController: TRBaseViewController?
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorBGImage: UIImageView!
    @IBOutlet var activityIndicatorTopConstraint: NSLayoutConstraint!
    
    func startActivityIndicator (vc: TRBaseViewController) {
        self.startActivityIndicator(vc, withClearBackGround: false, activityTopConstraintValue: nil)
    }
    
    func startActivityIndicator (vc: TRBaseViewController, withClearBackGround: Bool, activityTopConstraintValue: CGFloat?) {
        self.parentViewController = vc
        self.frame = (self.parentViewController?.view.bounds)!
        self.parentViewController?.view.addSubview(self)
        
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
            self.parentViewController?.displayAlertWithTitle("No Server Response", complete: { (complete) -> () in
                self.stopActivityIndicator()
                self.removeFromSuperview()
                self.timer.invalidate()
                self.parentViewController = nil
            })
        }
    }
}