//
//  TRSignInViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TRSignInViewController: TRBaseViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    
    private let xAxis: CGFloat = 0.0
    private let yAxisWithOpenKeyBoard: CGFloat = 235.0
    private let yAxisWithClosedKeyBoard: CGFloat = 20.0
    private var leftTapGesture: UITapGestureRecognizer?
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var userPwdTxtField: UITextField!
    @IBOutlet weak var forgotPassword: UILabel!
    @IBOutlet weak var playStationButton: UIButton!
    @IBOutlet weak var xBoxStationButton: UIButton!
    @IBOutlet weak var playStationImage: UIImageView!
    @IBOutlet weak var xBoxStationImage: UIImageView!
    @IBOutlet weak var appIconImage: UIImageView!
    @IBOutlet weak var viewInfoLabel: UILabel!
    
    
    var errorView: TRErrorNotificationView?
    var selectedConsole: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.leftTapGesture == nil {
            self.leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forgotPasswordTapped))
            self.leftTapGesture!.delegate = self
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSignInViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSignInViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)

        self.userPwdTxtField.attributedPlaceholder = NSAttributedString(string:"Enter password", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        self.forgotPassword.addGestureRecognizer(self.leftTapGesture!)
        
        //UnSelected Button View Updates
        self.playStationSelected()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.userNameTxtField?.isFirstResponder() == true {
           self.userNameTxtField?.resignFirstResponder()
        } else if self.userPwdTxtField?.isFirstResponder() == true {
            self.userPwdTxtField?.resignFirstResponder()
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        delay(0.5) {
            self.userNameTxtField?.becomeFirstResponder()
        }
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
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.userNameTxtField) {
            self.userPwdTxtField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.signInBtnTapped(self.userPwdTxtField)
        }
        
        return true
    }

    
    @IBAction func playStationSelected () {
        self.selectedConsole = ConsoleTypes.PS4
        self.playStationButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        self.playStationButton?.layer.cornerRadius = 2.0
        self.playStationButton?.alpha = 1
        self.playStationImage?.alpha = 1
        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter PlayStation Gamertag", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.xBoxStationButton?.backgroundColor = UIColor.blackColor()
        self.xBoxStationImage?.alpha = 0.5
        self.xBoxStationButton?.alpha = 0.5
    }

    @IBAction func xBoxSelected () {
        self.selectedConsole = ConsoleTypes.XBOXONE
        self.xBoxStationButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        self.xBoxStationButton?.layer.cornerRadius = 2.0
        self.xBoxStationButton?.alpha = 1
        self.xBoxStationImage?.alpha = 1
        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter Xbox Gamertag", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.playStationButton?.backgroundColor = UIColor.blackColor()
        self.playStationImage?.alpha = 0.5
        self.playStationButton?.alpha = 0.5
    }

    @IBAction func signInBtnTapped(sender: AnyObject) {

        // Close KeyBoards
        self.resignKeyBoardResponders()
        
        if userNameTxtField.text?.isEmpty  == true {
            let displatString: String?
            if self.selectedConsole == ConsoleTypes.PS4 {
                displatString = "PlayStation Gamertag"
            } else {
                displatString = "Xbox Gamertag"
            }
            
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter \(displatString!)")

            return
        }     
        if userPwdTxtField.text?.isEmpty == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Enter your password")
            
            return
        }

        guard let _ = self.selectedConsole else {
            return
        }
        
        let userInfo = TRUserInfo()
        userInfo.userName = userNameTxtField.text
        userInfo.password = userPwdTxtField.text
        
        //Saving Password here, since the backend won't be sending PW back and the current login flow is checking for UserName and PW
        //to let user login to home page.
        //Setting to "nil" if sign-in is not success
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(userPwdTxtField.text, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
        defaults.synchronize()

        var console = [String: AnyObject]()
        console["consoleType"] = self.selectedConsole
        console["consoleId"] = userNameTxtField.text
        let createRequest = TRAuthenticationRequest()
        
        var invitationDict = NSDictionary()
        if let invi = TRApplicationManager.sharedInstance.invitation {
            invitationDict = invi.createSignInInvitationPayLoad()
        }
        
        createRequest.loginTRUserWith(console, password: userPwdTxtField.text, invitationDict: invitationDict as? Dictionary<String, AnyObject>) { (error, responseObject) in
            if let errorString = error {
                if (errorString == "The username and password do not match our records.") {
                    TRApplicationManager.sharedInstance.addErrorSubViewWithMessage(errorString)
                    return
                } else if (errorString == "It looks like this account is on a legacy platform. We’re no longer able to display the information you seek.") {
                    let refreshAlert = UIAlertController(title: "Crossroads", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                        
                    }))
                    
                    self.presentViewController(refreshAlert, animated: true, completion: nil)
                } else {
                    //Delete the saved Password if sign-in was not successful
                    defaults.setValue(nil, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
                    defaults.synchronize()
                    
                    // Add Error View
                    let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                    let vc : TRSignInErrorViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SIGNIN_ERROR) as! TRSignInErrorViewController
                    vc.userName = self.userNameTxtField.text
                    vc.signInError = error
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                self.signInSuccess()
            }
        }
    }
    
    
    func forgotPasswordTapped (sender: UITapGestureRecognizer) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRForgotPasswordViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_FORGOT_PASSWORD) as! TRForgotPasswordViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        
        self.errorView?.frame = CGRectMake(xAxis, yAxisWithClosedKeyBoard, self.errorView!.frame.size.width, self.errorView!.frame.size.height)
        self.resignKeyBoardResponders()
    }
    
    @IBAction func showPasswordClicked () {
        
        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SHOW_PASSWORD, completion: {didSucceed in
            if didSucceed == true {
            }
        })
        
        if let _ = self.userPwdTxtField.text where self.userPwdTxtField.text?.isEmpty != true {
            let tmpString = self.userPwdTxtField?.text
            self.userPwdTxtField.secureTextEntry = !self.userPwdTxtField.secureTextEntry
            self.userPwdTxtField?.text = ""
            self.userPwdTxtField?.text = tmpString
        }
    }
    
    //MARK:-KEY-BOARD
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                    self.appIconImage?.alpha = 0
                    self.viewInfoLabel?.alpha = 0
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
        else {
            self.appIconImage?.alpha = 1
            self.viewInfoLabel?.alpha = 1
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
    }
}
