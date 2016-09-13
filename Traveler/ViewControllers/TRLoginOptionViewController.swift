//
//  TRLoginOptionViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRLoginOptionViewController: TRBaseViewController {
    
    @IBOutlet weak var playerCountLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countString = TRApplicationManager.sharedInstance.totalUsers?.description
        let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)]
        let countAttributedStr = NSAttributedString(string: countString!, attributes: stringColorAttribute)
        let helpAttributedStr = NSAttributedString(string: " Guardians looking for your help:", attributes: nil)
        
        let finalString:NSMutableAttributedString = countAttributedStr.mutableCopy() as! NSMutableAttributedString
        finalString.appendAttributedString(helpAttributedStr)

        self.playerCountLabel.attributedText = finalString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
