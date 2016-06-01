//
//  TRSignUpVerificatioViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TRSignUpVerificatioViewController: TRBaseViewController, TTTAttributedLabelDelegate {

    @IBOutlet weak var messageLable: TTTAttributedLabel?
    @IBOutlet weak var accountVerifyLabel: UILabel!
    @IBOutlet weak var signOutLabel: TTTAttributedLabel!
    @IBOutlet weak var messageFailErrorLable: TTTAttributedLabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var messageString = ""
        let bungieLinkName = "Bungie.net"
        
        if let userName = TRUserInfo.getUserName() {
            messageString = "Welcome \(userName) \n \nThanks for signing up for Crossroads, the Destiny Fireteam Finder! An account verification message has been sent to your \(bungieLinkName) account. Click the link in the message to verify your PSN ID."
        } else {
            messageString = "Welcome \n \nThanks for signing up for Crossroads, the Destiny Fireteam Finder! An account verification message has been sent to your bungie.net account. Click the link in the message to verify your PSN ID."
        }
        
        self.messageLable?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.rangeOfString(bungieLinkName)
        let url = NSURL(string: "https://www.bungie.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        self.messageLable?.linkAttributes = subscriptionNoticeLinkAttributes
        self.messageLable?.addLinkToURL(url, withRange: range)
        self.messageLable?.delegate = self
        
        
        //SignOut Text
        let signOutText = "Sign in with a different account?"
        self.signOutLabel?.text = signOutText
        let signOutString = signOutText as NSString
        let signOutRange = signOutString.rangeOfString(signOutText)
        let signOutUrl = NSURL(string: "logout")!
        let signoutLinkAttributes = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSUnderlineStyleAttributeName: NSNumber(bool:false),
        ]
        self.signOutLabel?.linkAttributes = signoutLinkAttributes
        self.signOutLabel?.addLinkToURL(signOutUrl, withRange: signOutRange)
        self.signOutLabel?.delegate = self
        
        
        //No message Text
        self.messageFailErrorLable?.textColor = UIColor.whiteColor()
        let messageFailOutText = "If you have not received a message within 10 minutes, send the message again. If the problem persists, contact us at support@crossroadsapp.co"
        let messageFailRangeString = "send the message again"
        let messageEmailRangeString = "support@crossroadsapp.co"
        
        self.messageFailErrorLable?.text = messageFailOutText
        let messageFailString = messageFailOutText as NSString
        let messageFailRange = messageFailString.rangeOfString(messageFailRangeString)
        let messageEmailFailRange = messageFailString.rangeOfString(messageEmailRangeString)
        
        let messageFailUrl = NSURL(string: "sendMessageAgain")!
        let messageFailLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
        ]
        
        self.messageFailErrorLable?.linkAttributes = messageFailLinkAttributes
        self.messageFailErrorLable?.addLinkToURL(messageFailUrl, withRange: messageFailRange)
        self.messageFailErrorLable?.addLinkToURL(NSURL(string: ""), withRange: messageEmailFailRange)
        self.messageFailErrorLable?.delegate = self

        
        //Add FireBase
        self.addFireBaseObserverAndCheckVerification()
    }

    func addFireBaseObserverAndCheckVerification () {
        TRApplicationManager.sharedInstance.fireBaseObj.addUserObserverWithCompletion { (didCompelete) in
            if didCompelete == true {
                if TRUserInfo.isUserVerified() {
                    
                    var messageString = ""
                    if let userName = TRUserInfo.getUserName() {
                        messageString = "Welcome \(userName) \n \nThanks for signing up for Crossroads, the Destiny Fireteam Finder!"
                    } else {
                        messageString = "Welcome \n \nThanks for signing up for Crossroads, the Destiny Fireteam Finder!"
                    }

                    self.messageLable?.text = messageString
                    self.accountVerifyLabel.text = "Account Verified!"
                    
                    delay(3.0, closure: {
                        self.dismissViewController(true, dismissed: { (didDismiss) in
                            TRApplicationManager.sharedInstance.fireBaseObj.removeObservers()
                        })
                    })
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        
        if url.absoluteString == "logout" {
            self.addLogOutAlert()
            return
        } else if url.absoluteString == "sendMessageAgain" {
            self.resentMessageToBungie()
            return
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    func resentMessageToBungie () {
        _ = TRResendBungieVerification().resendVerificationRequest("", completion: { (didSucceed) in
            if didSucceed == true {

                let refreshAlert = UIAlertController(title: "", message: "Message Sent", preferredStyle: UIAlertControllerStyle.Alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    
                }))
                
                self.presentViewController(refreshAlert, animated: true, completion: nil)
            }
        })
    }
    
    func addLogOutAlert () {
        let refreshAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
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
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }

    deinit {
        
    }

}
