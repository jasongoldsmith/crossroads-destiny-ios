//
//  TRSignInErrorViewController.swift
//  Traveler
//
//  Created by Ashutosh on 9/14/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import MessageUI
import TTTAttributedLabel


class TRSignInErrorViewController: TRBaseViewController, TTTAttributedLabelDelegate, MFMailComposeViewControllerDelegate {
    
    var userName: String?
    var signInError: String?
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var starOneLabel: UILabel!
    @IBOutlet weak var starTwoLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var supportText: TTTAttributedLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoView?.layer.cornerRadius = 2.0
        self.starOneLabel?.text = "\u{02726}"
        self.starTwoLabel?.text = "\u{02726}"
        
        if let _ = self.userName {
            if let errorString = self.signInError {
                self.userInfoLabel?.text = errorString
            }
            
            self.userNameLabel?.text = self.userName!
        }
        
        self.supportText?.delegate = self
        let emailLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            ]
        self.supportText?.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        self.supportText?.text = "If you are still having login issues, email us at support@crossroadsapp.co or contact us directly."
        self.supportText?.linkAttributes = emailLinkAttributes
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func openContactUs () {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRSendReportViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as! TRSendReportViewController

        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func closeView () {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
//        let emailTitle = "Crossroads for Destiny Support Request"
//        let messageBody = "Please include your device and gamertag for the fastest assistance."
//        let toRecipents = ["support@crossroadsapp.co"]
//        let mc: MFMailComposeViewController = MFMailComposeViewController()
//        mc.mailComposeDelegate = self
//        mc.setSubject(emailTitle)
//        mc.setMessageBody(messageBody, isHTML: false)
//        mc.setToRecipients(toRecipents)
//        
//        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result {
        case MFMailComposeResultCancelled:
            print("Mail cancelled")
        case MFMailComposeResultSaved:
            print("Mail saved")
        case MFMailComposeResultSent:
            print("Mail sent")
        case MFMailComposeResultFailed:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    deinit {
        
    }
}