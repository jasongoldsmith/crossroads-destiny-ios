//
//  TRForgotPasswordViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/11/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel

private let PICKER_COMPONET_COUNT = 1

class TRForgotPasswordViewController: TRBaseViewController, TTTAttributedLabelDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var resetButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var resetTextBoxParentView: UIView!
    @IBOutlet weak var titleMessageLable: TTTAttributedLabel!
    @IBOutlet weak var consoleTypeLabel: UILabel!
    @IBOutlet weak var changeConsoleButton: UIButton!
    @IBOutlet weak var consoleImage: UIImageView!
    @IBOutlet weak var consolePicketContainerView: UIView!
    @IBOutlet weak var consolePicketView: UIPickerView!
    
    var consoleNameArray: NSArray = ["PlayStation 4","PlayStation 3", "Xbox 360", "Xbox One"]
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRForgotPasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRForgotPasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)

        self.userNameTextField.attributedPlaceholder = NSAttributedString(string:"Enter PlayStation ID", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        self.userNameTextField?.becomeFirstResponder()
        
        // layer Radius
        self.consolePicketView.layer.cornerRadius = 5.0
        self.consolePicketView.layer.masksToBounds = true
        
        self.changeConsoleButton.layer.cornerRadius = 3.0
        self.changeConsoleButton.layer.masksToBounds = true
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
    
    
    @IBAction func changeConsoleButtonPressed (sender: UIButton) {
        self.consolePicketContainerView.hidden = false

        //Close KeyBoard
        if self.userNameTextField?.isFirstResponder() == true {
            self.userNameTextField?.resignFirstResponder()
        }
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
        if textField.text?.characters.count >= 3 {
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
        
        let consoleName = self.consoleNameArray.objectAtIndex(self.selectedIndex) as! String
        let consoleType = self.getConsoleTypeFromString(consoleName)
            
        _ = TRForgotPasswordRequest().resetUserPassword(userName, consoleType: consoleType, completion: { (didSucceed) in
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
    
    
    //#MARK:- PICKER_VIEW
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return PICKER_COMPONET_COUNT
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.consoleNameArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.consoleNameArray.objectAtIndex(row) as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.userNameTextField.text = nil
        self.selectedIndex = row
    }
    
    @IBAction func closePickerView(recognizer : UITapGestureRecognizer) {
        
        self.consolePicketContainerView.hidden = true
        
        if let consoleType = self.consoleNameArray.objectAtIndex(self.selectedIndex) as? String {
            self.changeConsoleButton?.titleLabel?.text = consoleType
            
            if self.selectedIndex < 2 {
                self.consoleTypeLabel.text = "PLAYSTATION ID"
                self.userNameTextField.attributedPlaceholder = NSAttributedString(string:"Enter PlayStation ID", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
                self.consoleImage.image = UIImage(named: "iconPsnConsole")
            } else {
                self.consoleTypeLabel.text = "XBOX GAMERTAG"
                self.userNameTextField.attributedPlaceholder = NSAttributedString(string:"Enter Xbox Gamertag", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
                self.consoleImage.image = UIImage(named: "iconXboxoneConsole")
            }
        }
    }
    
    func getConsoleTypeFromString (consoleName: String) -> String {
        
        var consoleType = ""
        switch consoleName {
        case "PlayStation 4":
            consoleType = ConsoleTypes.PS4
            break
        case "PlayStation 3":
            consoleType = ConsoleTypes.PS3
            break
        case "Xbox 360":
            consoleType = ConsoleTypes.XBOX360
            break
            
        default:
            consoleType = ConsoleTypes.XBOXONE
            break
        }
        
        return consoleType
    }
    
    deinit {
        
    }
}
