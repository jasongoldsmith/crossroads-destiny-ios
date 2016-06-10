//
//  TRForgotPasswordViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/11/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TRForgotPasswordViewController: TRBaseViewController, TTTAttributedLabelDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var resetButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var resetTextBoxParentView: UIView!
    @IBOutlet weak var titleMessageLable: TTTAttributedLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRForgotPasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRForgotPasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)

        self.userNameTextField.attributedPlaceholder = NSAttributedString(string:"Enter username", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        self.userNameTextField?.becomeFirstResponder()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if self.userNameTextField.text!.isEmpty {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter PSN ID!")
            return false
        }
        
        self.forgotPasswordForPsnID(self.userNameTextField!.text!)
        
        return true
    }
    
    @IBAction func textFieldDidDidUpdate (textField: UITextField) {
        if textField.text?.characters.count >= 4 {
            self.resetPasswordButton.enabled = true
            self.resetPasswordButton.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        } else {
            self.resetPasswordButton.enabled = false
            self.resetPasswordButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
        }
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        
        if self.userNameTextField.isFirstResponder() {
            self.userNameTextField.resignFirstResponder()
        }
        
        delay(0.3) {
            self.dismissViewController(true) { (didDismiss) in
                
            }
        }
    }

    @IBAction func resetButtonPressed (sender: UIButton) {
        if self.userNameTextField.text!.isEmpty {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter PSN ID!")
        }
        
        self.forgotPasswordForPsnID(self.userNameTextField!.text!)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size

        self.resetButtonBottomConstraint!.constant = keyboardSize.height
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.resetButtonBottomConstraint!.constant = 0
    }
    
    //MARK:- NETWORK CALL
    func forgotPasswordForPsnID (userName: String) {
        _ = TRForgotPasswordRequest().resetUserPassword(userName, completion: { (didSucceed) in
            if (didSucceed == true) {
                
                self.resetTextBoxParentView.hidden = true
                self.resetPasswordButton.hidden = true
                
                let messageString = "A Reset Password Link Has Been Sent to Your Bungie.net Account."
                let bungieString = "Bungie.net"
                self.titleMessageLable.text = messageString
                
                // Add HyperLink to Bungie
                let nsString = messageString as NSString
                let rangeBungieString = nsString.rangeOfString(bungieString)
                let urlBungieString = NSURL(string: "https://www.bungie.net/")!
                let linkAttributes = [
                    NSUnderlineStyleAttributeName: NSNumber(bool:true),
                ]
                
                self.titleMessageLable?.linkAttributes = linkAttributes
                self.titleMessageLable?.addLinkToURL(urlBungieString, withRange: rangeBungieString)
                self.titleMessageLable?.delegate = self
                
                if self.userNameTextField?.isFirstResponder() == true {
                    self.userNameTextField?.resignFirstResponder()
                }
            } else {
            }
        })
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
    
    deinit {
        
    }
}
