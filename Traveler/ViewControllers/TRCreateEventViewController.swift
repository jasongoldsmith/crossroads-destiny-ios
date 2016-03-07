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
    
    func backButtonPressed (sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.didMoveToParentViewController(nil)
            self.removeFromParentViewController()
        }
    }
    
    @IBAction func activityButtonPressed (sender: EventButton) {
        self.addButtonBorder(sender)
    }
    
    @IBAction func cancelButtonPressed (sender: UIButton) {
        for view in self.view.subviews as [UIView] {
            if view.isKindOfClass(EventButton) {
                self.removeButtonBorde((view as? EventButton)!)
            }
        }
    }
    
    @IBAction func nextButtonPressed (sender: UIButton) {
        
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