//
//  TRReverseAnimation.swift
//  Traveler
//
//  Created by Ashutosh on 5/3/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


class TRReverseAnimation:  UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
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
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        transitionContext.containerView()!.addSubview(toViewController.view)
        transitionContext.containerView()!.addSubview(fromViewController.view)
        
        fromViewController.view.frame = CGRectMake(0, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height)
        UIView.animateWithDuration(ANIMATION_DURATION, animations: {
            fromViewController.view.frame = CGRectMake(0, fromViewController.view.frame.size.height, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height)
            }, completion: { (finished) in
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