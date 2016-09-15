//
//  TRSendReportViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/31/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


class TRSendReportViewController: TRBaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var reportTextView: UITextView!
    
    override func viewDidLoad() {
         super.viewDidLoad()

        self.title = "CONTACT US"
        self.addNavigationBarButtons(false, showCancel: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func navBackButtonPressed (sender: UIBarButtonItem?) {
        
        if self.reportTextView.isFirstResponder() {
            self.reportTextView.resignFirstResponder()
        }

        self.dismissViewController(true, dismissed: { (didDismiss) in
            self.didMoveToParentViewController(nil)
            self.removeFromParentViewController()
        })
    }

    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height - 65
                })
            }
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
        
    }
    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        if self.reportTextView.isFirstResponder() {
            self.reportTextView.resignFirstResponder()
        }
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.reportTextView.resignFirstResponder()
            self.sendReportButtonAdded(self.reportTextView)
        }
        
        return true
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        if self.view.frame.origin.y == self.view.frame.origin.y - keyboardSize.height {
            self.view.frame.origin.y += keyboardSize.height
        }
        else {
            self.view.frame.origin.y = 0
        }
    }

    
    @IBAction func sendReportButtonAdded (sender: AnyObject) {
        
        guard let currentUserID = TRUserInfo.getUserID() else {
            return
        }
        
        let textString: String = (self.reportTextView?.text)!
        if (textString.characters.count == 0) {
            
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a message")
            return
        }
        
        if textString == "Yatri" {
            
            let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let yatriViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_YATRI) as! YTGameViewController
            self.presentViewController(yatriViewController, animated: true, completion: {
                
            })

            return
        }
        
        _ = TRCreateAReportRequest().sendCreatedReport((self.reportTextView?.text)!, reportType: "issue", reporterID: currentUserID, completion: { (didSucceed) in
            if (didSucceed != nil)  {

                if self.reportTextView.isFirstResponder() {
                    self.reportTextView.resignFirstResponder()
                }

                self.displayAlertWithTitle("Message Sent", complete: { (complete) in
                    self.dismissViewController(true, dismissed: { (didDismiss) in
                        self.didMoveToParentViewController(nil)
                        self.removeFromParentViewController()
                    })
                })
            } else {
                
            }
        })
    }
}
