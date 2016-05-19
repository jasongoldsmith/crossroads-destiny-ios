//
//  TRForgotPasswordViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/11/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRForgotPasswordViewController: TRBaseViewController {

    @IBOutlet weak var psnIDTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var resetButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var resetTextBoxParentView: UIView!
    @IBOutlet weak var titleMessageLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRForgotPasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRForgotPasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)

        self.psnIDTextField.attributedPlaceholder = NSAttributedString(string:"Enter PSN ID", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        self.psnIDTextField?.becomeFirstResponder()
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
        
        if self.psnIDTextField.text!.isEmpty {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter PSN ID!")
            return false
        }
        
        self.forgotPasswordForPsnID(self.psnIDTextField!.text!)
        
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
        
        if self.psnIDTextField.isFirstResponder() {
            self.psnIDTextField.resignFirstResponder()
        }
        
        delay(0.3) {
            self.dismissViewController(true) { (didDismiss) in
                
            }
        }
    }

    @IBAction func resetButtonPressed (sender: UIButton) {
        if self.psnIDTextField.text!.isEmpty {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter PSN ID!")
        }
        
        self.forgotPasswordForPsnID(self.psnIDTextField!.text!)
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
    func forgotPasswordForPsnID (psnId: String) {
        _ = TRForgotPasswordRequest().resetUserPassword(psnId, completion: { (didSucceed) in
            if (didSucceed == true) {
                self.resetTextBoxParentView.hidden = true
                
                let stringUnderLineAttr = [NSUnderlineStyleAttributeName: NSNumber(bool:true)]
                let firstString = NSAttributedString(string: "A reset password message has been sent to your ")
                let middleString = NSAttributedString(string: "bungie.net", attributes: stringUnderLineAttr)
                let lastString = NSAttributedString(string: " account!")
                
                let finalString = NSMutableAttributedString()
                finalString.appendAttributedString(firstString)
                finalString.appendAttributedString(middleString)
                finalString.appendAttributedString(lastString)
                self.titleMessageLable.attributedText = finalString
                
                self.resetPasswordButton.enabled = false
                self.resetPasswordButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
                
                if self.psnIDTextField?.isFirstResponder() == true {
                    self.psnIDTextField?.resignFirstResponder()
                }
            } else {
            }
        })
    }
    
    deinit {
        
    }
}
