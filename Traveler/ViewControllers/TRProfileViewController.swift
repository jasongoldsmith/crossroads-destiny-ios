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
    @IBOutlet weak var backGroundImageView: UIImageView?
    
    var currentUser: TRPlayerInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func updateView () {
        self.currentUser = TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()
        
        if let _ = self.currentUser {
            if let userImage = self.currentUser?.playerImageUrl {
                let imageURL = NSURL(string: userImage)
                self.avatorImageView?.sd_setImageWithURL(imageURL)
                TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.avatorImageView!, borderWidth: 2.0)
            }
            
            // User's psnID
            self.avatorUserName?.text = self.currentUser?.playerPsnID
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.backGroundImageView?.bounds = self.view.frame
//        self.backGroundImageView?.clipsToBounds = true
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