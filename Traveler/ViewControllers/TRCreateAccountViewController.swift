//
//  TRCreateAccountViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRCreateAccountViewController: TRBaseViewController, UITextFieldDelegate {
    
    private let xAxis: CGFloat = 0.0
    private let yAxisWithOpenKeyBoard: CGFloat = 235.0
    private let yAxisWithClosedKeyBoard: CGFloat = 20.0
    private var isShowingKeyBoard: Bool?
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var userPwdTxtField: UITextField!
    @IBOutlet weak var userPSNIDTxtField: UITextField!
    
    var errorView: TRErrorNotificationView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: self.view.window)

        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter username", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        self.userPwdTxtField.attributedPlaceholder = NSAttributedString(string:"Enter password", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        self.userPSNIDTxtField.attributedPlaceholder = NSAttributedString(string:"Enter PSN ID", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.userPSNIDTxtField.delegate = self
        
        //Set Status Bar Background
        self.setStatusBarBackgroundColor(UIColor.blackColor())
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.isShowingKeyBoard = false
        self.resignFirstResponder()
        self.createAccountBtnTapped(textField)
        
        return true
    }
    
    @IBAction func handleSwipeRight(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createAccountBtnTapped(sender: AnyObject) {
        
        if userNameTxtField.text?.isEmpty  == true {
            self.errorView = TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Enter UserName", parentView: self)
            self.view.addSubview(self.errorView!)
            self.adjustKeyBoardFrame()
            
            return
        } else {
            let textcount = userNameTxtField.text?.characters.count
            if textcount < 4 || textcount > 50 {
                self.errorView = TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("User Name must be between 4 and 50 characters", parentView: self)
                self.view.addSubview(self.errorView!)
                self.adjustKeyBoardFrame()
                
                return
            }
        }
        
        if userPwdTxtField.text?.isEmpty == true {
            self.errorView = TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Enter UserPassword", parentView: self)
            self.view.addSubview(self.errorView!)
            self.adjustKeyBoardFrame()
            
            return
        } else {
            
            let textcount = userPwdTxtField.text?.characters.count
            if textcount < 4 || textcount > 50 {
                self.errorView = TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("User password must be between 4 and 50 characters", parentView: self)
                self.view.addSubview(self.errorView!)
                self.adjustKeyBoardFrame()
                
                return
            }
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

                self.view.addSubview(TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Your credentails info is wrong", parentView: self))
            }
        }
    }
    
    func createAccountSuccess() {
        
        performSegueWithIdentifier("TRAccountCreationUnwindAction", sender: nil)
    }
    
    func adjustKeyBoardFrame () {
        if (self.isShowingKeyBoard == true) {
            self.errorView?.frame = CGRectMake(xAxis, yAxisWithOpenKeyBoard, self.errorView!.frame.size.width, self.errorView!.frame.size.height)
        } else {
            self.errorView?.frame = CGRectMake(xAxis, yAxisWithClosedKeyBoard, self.errorView!.frame.size.width, self.errorView!.frame.size.height)
        }
    }
    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        
        self.isShowingKeyBoard = false
        
        self.errorView?.frame = CGRectMake(xAxis, yAxisWithClosedKeyBoard, self.errorView!.frame.size.width, self.errorView!.frame.size.height)
        
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
    
    
    func keyboardWillShow(sender: NSNotification) {
        
        self.isShowingKeyBoard = true
        self.errorView?.frame = CGRectMake(xAxis, yAxisWithOpenKeyBoard, self.errorView!.frame.size.width, self.errorView!.frame.size.height)
        
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
