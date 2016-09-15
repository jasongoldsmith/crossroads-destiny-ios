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
    var branchLinkData: NSDictionary? = nil
    
    private let ACTIVITY_INDICATOR_TOP_CONSTRAINT: CGFloat = 365.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadAppInitialViewController()
    }

    func loadAppInitialViewController () {
        if (TRUserInfo.isUserLoggedIn()) {
            if (TRUserInfo.isUserVerified() == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let userInfo = TRUserInfo()
                userInfo.userName = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserName) as? String
                userInfo.password = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserPwd) as? String

                let createRequest = TRAuthenticationRequest()
                createRequest.loginTRUserWith(userInfo) { (value ) in
                    if value == true {
                        
                        _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: true, indicatorTopConstraint: self.ACTIVITY_INDICATOR_TOP_CONSTRAINT, completion: { (didSucceed) -> () in
                            
                            var showEventListLandingPage = false
                            var showGroups = false
                            
                            if(didSucceed == true) {
                                let userDefaults = NSUserDefaults.standardUserDefaults()
                                let shownGroupBool = userDefaults.boolForKey(K.UserDefaultKey.SHOWN_GROUP_PICKER)
                                if (shownGroupBool == true) {
                                    showEventListLandingPage = true
                                } else if TRApplicationManager.sharedInstance.eventsList.count > 0 {
                                    showGroups = true
                                    userDefaults.setBool(true, forKey: K.UserDefaultKey.SHOWN_GROUP_PICKER)
                                }
                                
                                TRApplicationManager.sharedInstance.addSlideMenuController(self, pushData: self.pushNotificationData, branchData: self.branchLinkData, showLandingPage: showEventListLandingPage, showGroups: showGroups)
                                
                                self.pushNotificationData = nil
                            } else {
                                self.appManager.log.debug("Failed")
                            }
                        })
                    } else{
                        
                        //Delete the saved Password if sign-in was not successful
                        userDefaults.setValue(nil, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
                        userDefaults.synchronize()
                        
                        // Add Error View
                        TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("The username and password do not match. Please try again.")
                    }
                }
            }
        } else {
            //loginOptions // Get Public Feed 
            _ = TRPublicFeedRequest().getPublicFeed({ (didSucceed) in
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : TRLoginOptionViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_LOGIN_OPTIONS) as! TRLoginOptionViewController
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.navigationBar.hidden = true
                self.presentViewController(navigationController, animated: true, completion: {
                    
                })
            })
        }
    }
    
    
    @IBAction func trUnwindAction(segue: UIStoryboardSegue) {
        
    }
}

