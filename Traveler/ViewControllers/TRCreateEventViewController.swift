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
 
    var selectedButton              : EventButton?
    @IBOutlet var activityIcon      : UIImageView?
    @IBOutlet var cancelButton      : UIButton?
    @IBOutlet var nextBUtton        : UIButton?
    @IBOutlet var activityOneButton     : EventButton?
    @IBOutlet var activityTwoButton     : EventButton?
    @IBOutlet var activityThreeButton   : EventButton?
    
    
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
        
        //Fetch Activities by Type
        for (_, activity) in TRApplicationManager.sharedInstance.activityList.enumerate() {
            if (activity.activityType == "Raid" && activityOneButton?.buttonActivityInfo == nil) {
                activityOneButton?.buttonActivityInfo = activity
            } else if (activity.activityType == "Weeklies" && activityTwoButton?.buttonActivityInfo == nil) {
                activityTwoButton?.buttonActivityInfo = activity
            } else {
                if (activityThreeButton?.buttonActivityInfo == nil) {
                    activityThreeButton?.buttonActivityInfo = activity
                }
            }
        }
    }
    
    func addNavigationBarButtons () {
        //Adding Back Button to nav Bar
        let leftButton = UIButton(frame: CGRectMake(0,0,30,30))
        leftButton.setImage(UIImage(named: "iconBackArrow"), forState: .Normal)
        leftButton.addTarget(self, action: Selector("backButtonPressed:"), forControlEvents: .TouchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = leftButton
        
        // Avator Image View
        let imageUrl = NSURL(string: (TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()?.playerImageUrl)!)
        let avatorImageView = UIImageView()
        avatorImageView.sd_setImageWithURL(imageUrl)
        let avatorImageFrame = CGRectMake((self.navigationController?.navigationBar.frame.width)! - avatorImageView.frame.size.width - 50, (self.navigationController?.navigationBar.frame.height)! - avatorImageView.frame.size.height - 40, 30, 30)
        avatorImageView.frame = avatorImageFrame
        TRApplicationManager.sharedInstance.imageHelper.roundImageView(avatorImageView)
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationController?.navigationBar.addSubview(avatorImageView)
    }
    
    func backButtonPressed (sender: UIBarButtonItem?) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.didMoveToParentViewController(nil)
            self.removeFromParentViewController()
        }
    }
    
    @IBAction func activityButtonPressed (sender: EventButton) {
        
        if let _ = self.selectedButton {
            self.removeButtonHighlight(self.selectedButton!)
        }
        
        self.selectedButton = sender
        self.addButtonBorder(sender)
    }
    
    @IBAction func cancelButtonPressed (sender: UIButton) {
        self.backButtonPressed(nil)
    }
    
    @IBAction func nextButtonPressed (sender: UIButton) {
        
        if let _ = self.selectedButton?.buttonActivityInfo {
            let vc = TRApplicationManager.sharedInstance.stroryBoardManager.getViewControllerWithID(K.ViewControllerIdenifier.VIEW_CONTROLLER_CREATE_EVENT_ACTIVITY, storyBoardID: K.StoryBoard.StoryBoard_Main) as! TRCreateEventsActivityViewController
            vc.seletectedActivity = self.selectedButton?.buttonActivityInfo
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func removeButtonHighlight (sender: EventButton) {
        self.removeButtonBorde(sender)
    }
    
    func addButtonBorder (sender: EventButton) {
        if sender.layer.borderWidth == 0 {
            sender.layer.borderWidth = 1.0
            sender.layer.borderColor = UIColor(red: 96/255, green: 184/255, blue: 0/255, alpha: 1).CGColor
        }
    }
    
    func removeButtonBorde (sender: EventButton) {
        sender.layer.borderWidth = 0
        sender.layer.borderColor = UIColor.clearColor().CGColor
    }
}