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
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendButtonBottomConst: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailView?.layer.cornerRadius = 2.0
        self.reportTextView?.layer.cornerRadius = 2.0
        self.emailView?.clipsToBounds = true
        
        self.emailTextView?.attributedPlaceholder = NSAttributedString(string:"Your Email (required)", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSendReportViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSendReportViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
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
    
    
    @IBAction func navBackButtonPressed () {
        
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
                    self.sendButtonBottomConst?.constant = keyboardSize.height
                    self.view.layoutIfNeeded()
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
            self.sendButtonBottomConst?.constant = 0
            self.view.layoutIfNeeded()
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
        
        let emailString: String = (self.emailTextView?.text)!
        if self.isValidEmail(emailString) == false {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a valid email address")
            return
        }
        
        if textString == "Yatri" {
            
            let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let yatriViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_YATRI) as! YTGameViewController
            self.presentViewController(yatriViewController, animated: true, completion: {
                
            })

            return
        }
        
        _ = TRCreateAReportRequest().sendCreatedReport(emailString, reportDetail:(self.reportTextView?.text)!, reportType: "issue", reporterID: currentUserID, completion: { (didSucceed) in
            if (didSucceed != nil)  {

                if self.reportTextView.isFirstResponder() {
                    self.reportTextView.resignFirstResponder()
                }

                let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CONTACT_MESSAGE_SENT) as! TRMessageSentConfViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {}
        })
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
}
