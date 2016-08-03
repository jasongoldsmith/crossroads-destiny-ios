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
        
        //Check if Legal statement has been updated
        if TRUserInfo.isLegalAlertShown() == false {
            self.displayAlertWithTitleAndMessageAnOK("Update", message: "Our Terms of Service and Privacy Policy have changed. \n\n By tapping the “OK” button, you agree to the updated Terms of Service and Privacy Policy", complete: { (complete) in
                if complete == true {
                    TRUserInfo.saveLegalAlertDefault()
                    self.loadAppInitialViewController()
                }
            })
        } else {
            self.loadAppInitialViewController()
        }
    }

    func loadAppInitialViewController () {
        if (TRUserInfo.isUserLoggedIn()) {
            if (TRUserInfo.isUserVerified() == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                
                _ = TRGetUserRequest().getUserByID(TRUserInfo.getUserID()!, completion: { (userObject) in
                    if let _ = userObject {
                        
                        _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: true, indicatorTopConstraint: self.ACTIVITY_INDICATOR_TOP_CONSTRAINT, completion: { (didSucceed) -> () in
                            
                            var showEventListLandingPage = false
                            var showGroups = false
                            
                            if(didSucceed == true) {
                                if (TRUserInfo.getUserClanID() == ACCOUNT_VERIFICATION.USER_NOT_VERIFIED.rawValue) {
                                    // If has events, show event list view else show create Activity View
                                    showGroups = true
                                } else if TRApplicationManager.sharedInstance.eventsList.count > 0 {
                                    showEventListLandingPage = true
                                }
                                
                                TRApplicationManager.sharedInstance.addSlideMenuController(self, pushData: self.pushNotificationData, branchData: self.branchLinkData, showLandingPage: showEventListLandingPage, showGroups: showGroups)
                                
                                self.pushNotificationData = nil
                            } else {
                                self.appManager.log.debug("Failed")
                            }
                        })
                    }
                })
            } else {
                let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let verifyAccountViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_VERIFY_ACCOUNT) as! TRSignUpVerificatioViewController
                self.presentViewController(verifyAccountViewController, animated: true, completion: {
                    
                })
            }
        } else {
            //loginOptions
            let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let vc : TRLoginOptionViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_LOGIN_OPTIONS) as! TRLoginOptionViewController
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.hidden = true
            self.presentViewController(navigationController, animated: true, completion: {
                
            })
        }
    }
    
    
    @IBAction func trUnwindAction(segue: UIStoryboardSegue) {
        
    }
}

