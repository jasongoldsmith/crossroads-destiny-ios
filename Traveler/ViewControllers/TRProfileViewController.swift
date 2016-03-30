//
//  TRProfileViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRProfileViewController: TRBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func logOutUser () {
        let createRequest = TRAuthenticationRequest()
        createRequest.logoutTRUser() { (value ) in
            if value == true {
                
                self.dismissViewControllerAnimated(false, completion:{
                    self.didMoveToParentViewController(nil)
                    self.removeFromParentViewController()
                })
                
                self.presentingViewController?.dismissViewControllerAnimated(false, completion: {
                    TRUserInfo.removeUserData()
                    TRApplicationManager.sharedInstance.purgeSavedData()

                    self.didMoveToParentViewController(nil)
                    self.removeFromParentViewController()
                })
            } else {
                self.displayAlertWithTitle("Logout Failed", complete: { (complete) -> () in
                })
            }
        }
    }
    
    @IBAction func backButtonPressed (sender: AnyObject) {
        self.dismissViewController(true) { (didDismiss) in
        }
    }
}