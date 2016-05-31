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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var messageString = ""
        let bungieLinkName = "bungie.net"
        
        if let userName = TRUserInfo.getUserName() {
            messageString = "Welcome \(userName) \n \nThanks for singning up for Crossroads, the Destiny Fireteam Finder mobile app! An account verification message has been sent to your \(bungieLinkName) account. Click the link in the message to verify your PSN ID."
        } else {
            messageString = "Welcome \n \nThanks for singning up for Crossroads, the Destiny Fireteam Finder mobile app! An account verification message has been sent to your bungie.net account. Click the link in the message to verify your PSN ID."
        }
        
        self.messageLable?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.rangeOfString(bungieLinkName)
        let url = NSURL(string: "https://www.bungie.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:false),
            ]
        self.messageLable?.linkAttributes = subscriptionNoticeLinkAttributes
        self.messageLable?.addLinkToURL(url, withRange: range)
        self.messageLable?.delegate = self
        
        //Add FireBase
        self.addFireBaseObserverAndCheckVerification()
    }

    func addFireBaseObserverAndCheckVerification () {
        TRApplicationManager.sharedInstance.fireBaseObj.addUserObserverWithCompletion { (didCompelete) in
            if didCompelete == true {
                if TRUserInfo.isUserVerified() {
                    
                    var messageString = ""
                    if let userName = TRUserInfo.getUserName() {
                        messageString = "Welcome \(userName) \n \nThanks for singning up for Crossroads, the Destiny Fireteam Finder mobile app!"
                    } else {
                        messageString = "Welcome \n \nThanks for singning up for Crossroads, the Destiny Fireteam Finder mobile app!"
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
        UIApplication.sharedApplication().openURL(url)
    }
    
    deinit {
        
    }

}
