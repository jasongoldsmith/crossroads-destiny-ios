//
//  TRCreateAccountViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TRCreateAccountViewController: TRBaseViewController, UITextFieldDelegate, TTTAttributedLabelDelegate, UIGestureRecognizerDelegate {
    
    private let xAxis: CGFloat = 0.0
    private let yAxisWithOpenKeyBoard: CGFloat = 235.0
    private let yAxisWithClosedKeyBoard: CGFloat = 20.0
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var userPwdTxtField: UITextField!
    @IBOutlet weak var userPSNIDTxtField: UITextField!
    @IBOutlet weak var legalStatementText: TTTAttributedLabel!
    
    
    var errorView: TRErrorNotificationView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRCreateAccountViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRCreateAccountViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)

        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter username", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        self.userPwdTxtField.attributedPlaceholder = NSAttributedString(string:"Enter password", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        self.userPSNIDTxtField.attributedPlaceholder = NSAttributedString(string:"Enter PSN ID", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.userPSNIDTxtField.delegate = self
        
        //Add legal Stings
        self.addLegalStatmentText()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view == self.legalStatementText  {
            return false
        }
        
        return true
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
        legalViewController.linkToOpen = url
        self.presentViewController(legalViewController, animated: true, completion: {
            
        })
    }

    func addLegalStatmentText () {
        let legalString = "By clicking the button below, I have read and agree to the Crossroads Terms of Service and Privacy Policy"
        
        let customerAgreement = "Terms of Service"
        let privacyPolicy = "Privacy Policy"
            
        self.legalStatementText?.text = legalString
        
        // Add HyperLink to Bungie
        let nsString = legalString as NSString
        
        let rangeCustomerAgreement = nsString.rangeOfString(customerAgreement)
        let rangePrivacyPolicy = nsString.rangeOfString(privacyPolicy)
        let urlCustomerAgreement = NSURL(string: "https://www.crossroadsapp.co/terms")!
        let urlPrivacyPolicy = NSURL(string: "https://www.crossroadsapp.co/privacy")!
        
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        self.legalStatementText?.linkAttributes = subscriptionNoticeLinkAttributes
        self.legalStatementText?.addLinkToURL(urlCustomerAgreement, withRange: rangeCustomerAgreement)
        self.legalStatementText?.addLinkToURL(urlPrivacyPolicy, withRange: rangePrivacyPolicy)
        self.legalStatementText?.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.userNameTxtField) {
            self.userPwdTxtField.becomeFirstResponder()
        } else if (textField == self.userPwdTxtField) {
            self.userPSNIDTxtField.becomeFirstResponder()
        } else {
            self.userPSNIDTxtField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func handleSwipeRight(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createAccountBtnTapped(sender: AnyObject) {
        
        //Close KeyBoard
        self.resignKeyBoardResponders()
        
        if userNameTxtField.text?.isEmpty  == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a username")
            
            return
        } else {
            let textcount = userNameTxtField.text?.characters.count
            if textcount < 4 || textcount > 50 {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Your username must have at least 5 characters.")
                
                return
            }
        }
        
        if userPwdTxtField.text?.isEmpty == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a password.")
            
            return
        } else {
            
            let textcount = userPwdTxtField.text?.characters.count
            if textcount < 4 || textcount > 50 {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Your password must have at least 5 characters.")
                
                return
            }
        }
     
        if userPSNIDTxtField.text?.isEmpty == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a PSN ID.")
            
            return
        }
        
        let userInfo = TRUserInfo()
        userInfo.userName = userNameTxtField.text
        userInfo.password = userPwdTxtField.text
        userInfo.psnID = userPSNIDTxtField.text
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(userPwdTxtField.text, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
        defaults.synchronize()


        let createRequest = TRAuthenticationRequest()
        createRequest.registerTRUserWith(userInfo) { (value ) in  //, errorData) in
            
            if value == true {
                self.createAccountSuccess()
            } else {
                
                //Delete the saved Password if sign-in was not successful
                defaults.setValue(nil, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
                defaults.synchronize()

                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Account creation failed.")
            }
        }
    }
    
    func createAccountSuccess() {
        
        performSegueWithIdentifier("TRAccountCreationUnwindAction", sender: nil)
    }
    
    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        
        self.errorView?.frame = CGRectMake(xAxis, yAxisWithClosedKeyBoard, self.errorView!.frame.size.width, self.errorView!.frame.size.height)
        self.resignKeyBoardResponders()
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
    
    func resignKeyBoardResponders () {
        if userNameTxtField.isFirstResponder() {
            userNameTxtField.resignFirstResponder()
        }
        if userPwdTxtField.isFirstResponder() {
            userPwdTxtField.resignFirstResponder()
        }
        if userPSNIDTxtField.isFirstResponder() {
            userPSNIDTxtField.resignFirstResponder()
        }
    }
}
