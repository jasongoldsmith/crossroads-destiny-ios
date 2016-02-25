//
//  TRSignInViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRSignInViewController: UIViewController {
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var userPwdTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: self.view.window)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func handleSwipeRight(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func signInSuccess() {
        
        performSegueWithIdentifier("TRSignInUnwindAction", sender: nil)
    }
    
    
    @IBAction func signInBtnTapped(sender: AnyObject) {
        
        if userNameTxtField.text?.isEmpty  == true {
            displayAlertWithTitle("Enter your UserName")
            return
        }
        else {
            let textcount = userNameTxtField.text?.characters.count
            if textcount < 4 || textcount > 50 {
                displayAlertWithTitle("User Name must be between 4 and 50 characters")
                return
            }
        }
        
        
        if userPwdTxtField.text?.isEmpty == true {
            displayAlertWithTitle("Enter your Password")
            return
            
        }
        else {
            
            let textcount = userPwdTxtField.text?.characters.count
            if textcount < 4 || textcount > 50 {
                displayAlertWithTitle("User password must be between 4 and 50 characters")
                return
            }
            
        }

        
        let userInfo = TRUserInfo()
        userInfo.userName = userNameTxtField.text
        userInfo.password = userPwdTxtField.text
        
        let createRequest = TRAuthenticationRequest()
        createRequest.loginTRUserWith(userInfo) { (value ) in  //, errorData) in
            
            if value == true {
                self.signInSuccess()
                
            }
            else
            {
                self.displayAlertWithTitle("Your credentails info is wrong")
            }
        }
        
        
    }
    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        
        if userNameTxtField.isFirstResponder() {
            userNameTxtField.resignFirstResponder()
        }
        else if userPwdTxtField.isFirstResponder() {
            userPwdTxtField.resignFirstResponder()
        }

    }
    
    
    func keyboardWillShow(sender: NSNotification) {

       
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        if self.view.frame.origin.y == self.view.frame.origin.y - keyboardSize.height {
        self.view.frame.origin.y += keyboardSize.height
        }
        else
        {
            self.view.frame.origin.y = 0
        }
    }
    
}
