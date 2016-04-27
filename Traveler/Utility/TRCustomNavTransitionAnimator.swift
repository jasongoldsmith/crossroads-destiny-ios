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
    var usingGesture:Bool = false
    
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
        _ = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        // Step 1: Add the view to the container view
        transitionContext.containerView()!.addSubview(toViewController.view)
        
        // Step 2: Apply your animation.
        toViewController.view.alpha = 0.0
        UIView.animateWithDuration(0.35, animations: {
            toViewController.view.alpha = 1.0
            }, completion: { (finished) in
                // Step 3: Call completion handler
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
    
    // MARK: Interactive Transitions
    func didPan(gesture: UIPanGestureRecognizer){
        let point = gesture.locationInView(transitioningController.view)
        let percent = fmaxf(fminf(Float(point.x / 300.0), 0.99), 0.0)
        switch (gesture.state){
        case .Began:
            self.usingGesture = true
            self.transitioningController.navigationController?.popViewControllerAnimated(true)
        case .Changed:
            self.updateInteractiveTransition(CGFloat(percent))
        case .Ended, .Cancelled:
            if percent > 0.5 {
                self.finishInteractiveTransition()
            } else {
                self.cancelInteractiveTransition()
            }
            self.usingGesture = false
        default:
            NSLog("Unhandled state")
        }
    }
}

