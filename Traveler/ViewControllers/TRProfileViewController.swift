//
//  TRProfileViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRProfileViewController: TRBaseViewController {
    
    
    @IBOutlet weak var avatorImageView: UIImageView?
    @IBOutlet weak var avatorUserName: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser() else {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Current User Information Error")
            return
        }
        
        if let userImage = currentUser.playerImageUrl {
            let imageURL = NSURL(string: userImage)
            self.avatorImageView?.sd_setImageWithURL(imageURL)
            TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.avatorImageView!, borderWidth: 2.0)
        }
        
        // User's psnID
        self.avatorUserName?.text = currentUser.playerPsnID
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
        TRApplicationManager.sharedInstance.slideMenuController.closeRight()
    }
    
    @IBAction func resetPassWordPressed (sender: AnyObject) {
        TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Reset - COMING SOON!")
    }
}