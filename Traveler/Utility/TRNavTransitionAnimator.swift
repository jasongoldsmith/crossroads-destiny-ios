//
//  TRCustomNavTransitionAnimator.swift
//  Traveler
//
//  Created by Ashutosh on 4/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRCustomNavTransitionAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    private let ANIMATION_DURATION = 0.35
    unowned var transitioningController: UIViewController
    var transitionInProgress:Bool = false
    
    init(transitioningController: UIViewController){
        self.transitioningController = transitioningController
    }
    
    func applyInterationTransitionHook(controller: UIViewController){
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(TRCustomNavTransitionAnimator.didPan(_:)))
        controller.view.addGestureRecognizer(panGesture)
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return ANIMATION_DURATION
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        transitionContext.containerView()!.addSubview(toViewController.view)
        
        toViewController.view.alpha = 0.0
        UIView.animateWithDuration(ANIMATION_DURATION, animations: {
            toViewController.view.alpha = 1.0
            }, completion: { (finished) in
                
                fromViewController?.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
    
    // MARK: Interactive Transitions
    func didPan(gesture: UIPanGestureRecognizer){
        let point = gesture.locationInView(transitioningController.view)
        let percent = fmaxf(fminf(Float(point.x / 300.0), 0.99), 0.0)
        switch (gesture.state){
        case .Began:
            self.transitionInProgress = true
            self.transitioningController.navigationController?.popViewControllerAnimated(true)
        case .Changed:
            self.updateInteractiveTransition(CGFloat(percent))
        case .Ended, .Cancelled:
            if percent > 0.5 {
                self.finishInteractiveTransition()
            } else {
                self.cancelInteractiveTransition()
            }
            self.transitionInProgress = false
        default:
            NSLog("Unhandled state")
        }
    }
}

