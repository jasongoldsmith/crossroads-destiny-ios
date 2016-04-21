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


class TRCreateEventViewController: TRBaseViewController {
 
    @IBOutlet var activityIcon          : UIImageView?
    @IBOutlet var activityFeaturedButton     : EventButton?
    @IBOutlet var activityRaidButton        : EventButton?
    @IBOutlet var activityArenaButton   : EventButton?
    @IBOutlet var activityCrucibleButton   : EventButton?
    @IBOutlet var activityStrikeButton   : EventButton?
    @IBOutlet var activityPatrolButton   : EventButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        nav?.barTintColor = UIColor(red: 10/255, green: 31/255, blue: 39/255, alpha: 1)
        
        addNavigationBarButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // This is going to be a temporary code, at present we have only couple of activity sub-types and we have UI designed only for that.
        // Will have to re-write this method when UI is updated to reflect number of activities
        
        for (_, activity) in TRApplicationManager.sharedInstance.activityList.enumerate() {
            switch activity.activityType! {
//            case K.ActivityType.FEATURED:
//                if activityFeaturedButton?.buttonActivityInfo == nil {
//                    activityFeaturedButton?.buttonActivityInfo = activity
//                }
//                break
            case K.ActivityType.RAIDS:
                if activityRaidButton?.buttonActivityInfo == nil {
                    activityRaidButton?.buttonActivityInfo = activity
                }
                break
            case K.ActivityType.CRUCIBLE:
                if activityCrucibleButton?.buttonActivityInfo == nil {
                    activityCrucibleButton?.buttonActivityInfo = activity
                }
                break
            case K.ActivityType.ARENA:
                if activityArenaButton?.buttonActivityInfo == nil {
                    activityArenaButton?.buttonActivityInfo = activity
                }
                break
            case K.ActivityType.STRIKES:
                if activityStrikeButton?.buttonActivityInfo == nil {
                    activityStrikeButton?.buttonActivityInfo = activity
                }
                break
            case K.ActivityType.PATROL:
                if activityPatrolButton?.buttonActivityInfo == nil {
                    activityPatrolButton?.buttonActivityInfo = activity
                }
                break

            default:
                break
            }
            
        }
        
    }
    
    func addNavigationBarButtons () {
        //Adding Back Button to nav Bar
        let leftButton = UIButton(frame: CGRectMake(0,0,44,44))
        leftButton.setImage(UIImage(named: "iconBackArrow"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(TRCreateEventViewController.navBackButtonPressed(_:)), forControlEvents: .TouchUpInside)
        leftButton.transform = CGAffineTransformMakeTranslation(-10, 0)
        
        // Add the button to a container, otherwise the transform will be ignored
        let leftButtonContainer = UIView(frame: leftButton.frame)
        leftButtonContainer.addSubview(leftButton)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = leftButtonContainer
        
        // Avator Image View
        if let imageString = TRUserInfo.getUserImageString() {
            let imageUrl = NSURL(string: imageString)
            let avatorImageView = UIImageView()
            avatorImageView.sd_setImageWithURL(imageUrl)
            let avatorImageFrame = CGRectMake((self.navigationController?.navigationBar.frame.width)! - avatorImageView.frame.size.width - 50, (self.navigationController?.navigationBar.frame.height)! - avatorImageView.frame.size.height - 40, 30, 30)
            avatorImageView.frame = avatorImageFrame
            avatorImageView.roundRectView()
            
            self.navigationController?.navigationBar.addSubview(avatorImageView)
        }

        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func navBackButtonPressed (sender: UIBarButtonItem?) {
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
        }
    }
}

