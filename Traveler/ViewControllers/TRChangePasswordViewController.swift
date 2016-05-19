//
//  TRChangePasswordViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/18/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRChangePasswordViewController: TRBaseViewController {

    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var oldPasswordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var passwordUpdatedLabel: UILabel!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldPassword.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRChangePasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRChangePasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        
        if self.oldPassword?.isFirstResponder() == true {
            self.oldPassword?.resignFirstResponder()
        } else {
            self.newPassword?.resignFirstResponder()
        }
        
        self.dismissViewController(true) { (didDismiss) in
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.oldPassword) {
            self.newPassword.becomeFirstResponder()
        } else {
            self.saveButtonPressed()
        }
        return true
    }
    
    
    @IBAction func textFieldDidDidUpdate (textField: UITextField) {
        if textField.text?.characters.count >= 4 {
            self.saveButton.enabled = true
            self.saveButton.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        } else {
            self.saveButton.enabled = false
            self.saveButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
        }
    }

    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        self.saveButtonBottomConstraint?.constant = keyboardSize.height
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.saveButtonBottomConstraint?.constant = 0
    }
    
    @IBAction func saveButtonPressed () {
        if self.oldPassword.text?.isEmpty == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter old password.")
            
            return
        } else if self.newPassword.text?.isEmpty == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter new password.")
            
            return
        }
    
        let _ = TRUpdateUser().updateUserObject(self.newPassword?.text, userImage: nil) { (didSucceed) in
            
            if didSucceed == true {
                self.oldPasswordView?.hidden = true
                self.newPasswordView?.hidden = true
                self.passwordUpdatedLabel?.hidden = false
                self.saveButton.enabled = false
                self.saveButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)

                if self.newPassword?.isFirstResponder() == true {
                    self.newPassword?.resignFirstResponder()
                }
            }
        }
    }
    
    deinit {
        
    }
}
