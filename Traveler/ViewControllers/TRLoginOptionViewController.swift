//
//  TRLoginOptionViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRLoginOptionViewController: TRBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func createAccountBtnTapped(sender: AnyObject) {
        if let _ = TRUserInfo.getConsoleID() where TRUserInfo.isUserVerified() == ACCOUNT_VERIFICATION.USER_VER_INITIATED.rawValue {
            let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let verifyAccountViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_SIGNUP) as! TRCreateAccountViewController
            self.navigationController?.pushViewController(verifyAccountViewController, animated: true)
        } else {
            
            _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SIGNUP_INIT, completion: {didSucceed in
                if didSucceed == true {
                }
            })

            let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let verifyAccountViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_BUNGIE_VERIFICATION) as! TRAddConsoleViewController
            self.navigationController?.pushViewController(verifyAccountViewController, animated: true)
        }
    }
    
    @IBAction func signIntBtnTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("TRSignInView", sender: self)
    }
    
    @IBAction func trUnwindActionToLoginOption(segue: UIStoryboardSegue) {
        
    }
}
