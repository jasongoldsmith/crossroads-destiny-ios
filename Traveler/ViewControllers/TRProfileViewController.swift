//
//  TRProfileViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import TTTAttributedLabel
import UIKit

class TRProfileViewController: TRBaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TTTAttributedLabelDelegate {
    
    
    @IBOutlet weak var avatorImageView: UIImageView?
    @IBOutlet weak var avatorUserName: UILabel?
    @IBOutlet weak var backGroundImageView: UIImageView?
    @IBOutlet weak var buildNumberLabel: TTTAttributedLabel!
    
    var currentUser: TRPlayerInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Update build number
        self.addVersionAndLegalAttributedLabel()
    }
    
    func addVersionAndLegalAttributedLabel () {
        
        let messageString = "Version: \(NSBundle.mainBundle().releaseVersionNumber!) - Build: \(NSBundle.mainBundle().buildVersionNumber!)  |  Legal"
        let legalString = "Legal"
        self.buildNumberLabel.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.rangeOfString(legalString)
        let url = NSURL(string: "https://www.bungie.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSUnderlineStyleAttributeName: NSNumber(bool:false),
            ]
        
        self.buildNumberLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.buildNumberLabel?.addLinkToURL(url, withRange: range)
        self.buildNumberLabel?.delegate = self
    }

    func updateView () {
        self.currentUser = TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()
        
        // User Image
        self.updateUserAvatorImage()
            
        // User's psnID
        if let hasUserName = self.currentUser?.playerUserName {
            self.avatorUserName?.text = hasUserName
        } else {
            self.avatorUserName?.text = TRUserInfo.getUserName()
        }
    }
    
    func updateUserAvatorImage () {
        
        //Avator for Current Player
        if self.avatorImageView?.image == nil {
            if let imageUrl = TRUserInfo.getUserImageString() {
                let imageUrl = NSURL(string: imageUrl)
                self.avatorImageView?.sd_setImageWithURL(imageUrl)
                self.avatorImageView?.roundRectView()
            }
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
        self.performSegueWithIdentifier("showChangePwView", sender: self)
    }
    
    @IBAction func sendReport () {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRSendReportViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as! TRSendReportViewController
        
        let navigationController = UINavigationController(rootViewController: vc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }

    //MARK:- Profile Image Picker Methods
    /*
    func presentProileImagePickerView () {
        let imageController = UIImagePickerController()
        imageController.editing = false
        imageController.delegate = self;
        
        let alert = UIAlertController(title: "Lets get a picture", message: "Just a message", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.Default) { (alert) -> Void in
            imageController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imageController, animated: true, completion: nil)
        }
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            //Camera available
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (alert) -> Void in
                imageController.sourceType = UIImagePickerControllerSourceType.Camera
                imageController.cameraDevice = UIImagePickerControllerCameraDevice.Front
                self.presentViewController(imageController, animated: true, completion: nil)
                
            }
            alert.addAction(cameraButton)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
            //Cancel Pressed
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerClosed(picker)
        }
    }
    
    func imagePickerClosed(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: ({
        }))
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.imagePickerClosed(picker)
    }
 */
}