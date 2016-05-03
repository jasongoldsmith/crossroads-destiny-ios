//
//  TRCreateEventViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/4/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


class TRCreateEventViewController: TRBaseViewController, UINavigationControllerDelegate {
 
    lazy var animator: TRCustomNavTransitionAnimator = TRCustomNavTransitionAnimator(transitioningController: self)
    
    @IBOutlet var activityIcon          : UIImageView?
    @IBOutlet var activityFeaturedButton     : EventButton?
    @IBOutlet var activityRaidButton        : EventButton?
    @IBOutlet var activityArenaButton   : EventButton?
    @IBOutlet var activityCrucibleButton   : EventButton?
    @IBOutlet var activityStrikeButton   : EventButton?
    @IBOutlet var activityPatrolButton   : EventButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is going to be a temporary code, at present we have only couple of activity sub-types and we have UI designed only for that.
        // Will have to re-write this method when UI is updated to reflect number of activities
        

        //Navigation
        self.title = "CREATE EVENT"
        self.addNavigationBarButtons()
        
        // INTERACTIVE VC ANIMATION
        //self.navigationController?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = TRgetActivityList().getActivityList({ (value) -> () in
            if (value == true) {
                for (_, activity) in TRApplicationManager.sharedInstance.activityList.enumerate() {
                    switch activity.activityType! {
                    case K.ActivityType.RAIDS:
                        if self.activityRaidButton?.buttonActivityInfo == nil {
                            self.activityRaidButton?.buttonActivityInfo = activity
                        }
                        break
                    case K.ActivityType.CRUCIBLE:
                        if self.activityCrucibleButton?.buttonActivityInfo == nil {
                            self.activityCrucibleButton?.buttonActivityInfo = activity
                        }
                        break
                    case K.ActivityType.ARENA:
                        if self.activityArenaButton?.buttonActivityInfo == nil {
                            self.activityArenaButton?.buttonActivityInfo = activity
                        }
                        break
                    case K.ActivityType.STRIKES:
                        if self.activityStrikeButton?.buttonActivityInfo == nil {
                            self.activityStrikeButton?.buttonActivityInfo = activity
                        }
                        break
                    case K.ActivityType.PATROL:
                        if self.activityPatrolButton?.buttonActivityInfo == nil {
                            self.activityPatrolButton?.buttonActivityInfo = activity
                        }
                        break
                        
                    default:
                        break
                    }
                }
            } else {
                self.appManager.log.debug("Activity List fetch failed")
            }
        })
    }
    
    override func navBackButtonPressed (sender: UIBarButtonItem?) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.didMoveToParentViewController(nil)
            self.removeFromParentViewController()
        }
    }
    
    @IBAction func activityButtonPressed (sender: EventButton) {
        
        if let _ = sender.buttonActivityInfo {
            
            let vc = TRApplicationManager.sharedInstance.stroryBoardManager.getViewControllerWithID(K.ViewControllerIdenifier.VIEW_CONTROLLER_CREATE_EVENT_SELECTION, storyBoardID: K.StoryBoard.StoryBoard_Main) as! TRCreateEventSelectionViewController
            vc.seletectedActivity = sender.buttonActivityInfo
            self.navigationController?.pushViewController(vc, animated: true)
            
            // INTERACTIVE VC ANIMATION
            //animator.applyInterationTransitionHook(vc)
        }
    }
    
    @IBAction func featuredActiviyButtonPressed (sender: EventButton) {
        let vc = TRApplicationManager.sharedInstance.stroryBoardManager.getViewControllerWithID(K.ViewControllerIdenifier.VIEW_CONTROLLER_CREATE_EVENT_SELECTION, storyBoardID: K.StoryBoard.StoryBoard_Main) as! TRCreateEventSelectionViewController
        vc.isFeaturedEvent = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animator.usingGesture {
            return animator
        } else {
            return nil
        }
    }
}

