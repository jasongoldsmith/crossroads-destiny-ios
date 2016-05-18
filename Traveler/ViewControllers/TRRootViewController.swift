//
//  TRRootViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift


class TRRootViewController: TRBaseViewController {
    
    // Push Data
    var pushNotificationData: NSDictionary? = nil
    
    private let ACTIVITY_INDICATOR_TOP_CONSTRAINT: CGFloat = 365.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if (TRUserInfo.isUserLoggedIn()) {
            if (TRUserInfo.isUserVerified()) {
                
                //If user is verified, check if he has Group, If no group then ask him to choose Group
                if let userClan = TRUserInfo.getUserClanID()  where userClan == "clan_id_not_set" {
                    //self.performSegueWithIdentifier("TRGroupsListView", sender: self)
                }
                
                _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: true, indicatorTopConstraint: ACTIVITY_INDICATOR_TOP_CONSTRAINT, completion: { (didSucceed) -> () in
                    
                    var showEventListLandingPage = false
                    if(didSucceed == true) {
                        if (TRApplicationManager.sharedInstance.eventsList.count > 0) {
                            showEventListLandingPage = true
                        }
                        TRApplicationManager.sharedInstance.addSlideMenuController(self, pushData: self.pushNotificationData, showLandingPage: showEventListLandingPage)
                        self.pushNotificationData = nil
                    } else {
                        self.appManager.log.debug("Failed")
                    }
                })
            } else {
                
                let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let verifyAccountViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_VERIFY_ACCOUNT) as! TRSignUpVerificatioViewController
                self.presentViewController(verifyAccountViewController, animated: true, completion: { 
                    
                })
                
                //Show User that he needs to verify
            }
        } else {
            self.performSegueWithIdentifier("TRLoginOptionView", sender: self)
        }
    }

    @IBAction func trUnwindAction(segue: UIStoryboardSegue) {
        
    }
}

