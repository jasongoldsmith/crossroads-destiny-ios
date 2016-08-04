//
//  TRAddConsoleViewController.swift
//  Traveler
//
//  Created by Ashutosh on 6/2/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import TTTAttributedLabel

private let PICKER_COMPONET_COUNT = 1

struct ConsoleTypes {
    static let PS4      = "PS4"
    static let PS3      = "PS3"
    static let XBOX360  = "XBOX360"
    static let XBOXONE  = "XBOXONE"
}

class TRAddConsoleViewController: TRBaseViewController, UITextFieldDelegate, TTTAttributedLabelDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var chooseConsoleButton: UIButton!
    @IBOutlet weak var legalLabel: TTTAttributedLabel!
    @IBOutlet weak var consoleIDTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var consolePicker: UIPickerView!
    @IBOutlet weak var consolePickerView: UIView!
    @IBOutlet weak var consoleTypeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addUpdateNewConsole: UIButton!
    @IBOutlet weak var consoleTagView: UIView!
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var consoleImage: UIImageView!
    
    
    var openedFromProfile: Bool = false
    var consoleNameArray: NSArray = ["PlayStation 4","PlayStation 3", "Xbox 360", "Xbox One"]
    var selectedIndex: Int = 0
    var preSelectedConsoleID: String?
    var isUpgrade: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add radius to button edges
        self.chooseConsoleButton?.layer.cornerRadius = 3.0
        
        // Placeholder text color
        self.consoleIDTextField.attributedPlaceholder = NSAttributedString(string:"Enter PlayStation ID", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        //PickerView
        self.consolePicker?.layer.cornerRadius = 5.0
        self.consolePicker?.layer.masksToBounds = true

        //KeyBoard Notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRCreateAccountViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRCreateAccountViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
    
        if self.openedFromProfile == true {
            self.chooseConsoleButton.setTitle(self.consoleNameArray.firstObject as? String, forState: .Normal)
            self.backButton.hidden = true
            self.closeButton.hidden = false
            self.legalLabel?.hidden = true
            self.nextButton.hidden = true
            self.addUpdateNewConsole.hidden = false
            self.upgradeLabel.hidden = false
        } else {
            self.backButton.hidden = false
            self.closeButton.hidden = true
            self.nextButton.hidden = false
            self.legalLabel?.hidden = false
            self.addUpdateNewConsole.hidden = true
            self.upgradeLabel.hidden = true
            self.addLegalStatmentText()
            self.consoleIDTextField.hidden = false
        }
        
        //Add Console Place Holder Text
        self.addConsolePlaceholderText()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addLegalStatmentText () {
        let legalString = "By clicking the \"Next\" button below, I have read and agree to the Crossroads Terms of Service and Privacy Policy."
        
        let customerAgreement = "Terms of Service"
        let privacyPolicy = "Privacy Policy"
        
        self.legalLabel?.text = legalString
        
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
        self.legalLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.legalLabel?.addLinkToURL(urlCustomerAgreement, withRange: rangeCustomerAgreement)
        self.legalLabel?.addLinkToURL(urlPrivacyPolicy, withRange: rangePrivacyPolicy)
        self.legalLabel?.delegate = self
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
        legalViewController.linkToOpen = url
        self.presentViewController(legalViewController, animated: true, completion: {
            
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.consoleIDTextField?.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldDidDidUpdate (textField: UITextField) {
        if self.consoleIDTextField?.text?.characters.count > 4 {
            self.nextButton?.enabled = true
            self.nextButton.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        } else {
            self.nextButton.enabled = false
            self.nextButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
        }
    }
    
    
    @IBAction func addUpdateConsole (sender: UIButton) {
        
        let playerConsoleID: String?
        if let _ = self.preSelectedConsoleID {
            playerConsoleID = self.preSelectedConsoleID
        } else {
            playerConsoleID = self.consoleIDTextField?.text
        }
        
        if let _ = playerConsoleID {
            if let consoleName  = self.consoleNameArray.objectAtIndex(self.selectedIndex) as? String {
                let consoleType = self.getConsoleTypeFromString(consoleName)
                
                if self.isUpgrade {
                    if consoleType == ConsoleTypes.PS4 || consoleType == ConsoleTypes.PS3 {
                        self.displayAlertWithTitleAndMessage("Warning", message: "Are you sure you want to upgrade to Playstation 4? This change will be permanent and you will no longer be able to view activities on Playstation 3", complete: { (complete) in
                            if complete == true {
                                _ = TRAddConsole().addUpdateConsole(playerConsoleID!, consoleType: consoleType, completion: { (didSucceed) in
                                    if didSucceed == true {
                                        self.showSuccessFor(consoleName, consoleID: playerConsoleID!)
                                    }
                                })
                            }
                        })
                    } else {
                        self.displayAlertWithTitleAndMessage("Warning", message: "Are you sure you want to upgrade to xBox One? This change will be permanent and you will no longer be able to view activities on xBox 360", complete: { (complete) in
                            if complete == true {
                                _ = TRAddConsole().addUpdateConsole(playerConsoleID!, consoleType: consoleType, completion: { (didSucceed) in
                                    if didSucceed == true {
                                        self.showSuccessFor(consoleName, consoleID: playerConsoleID!)
                                    }
                                })
                            }
                        })
                    }
                } else {
                    _ = TRAddConsole().addUpdateConsole(playerConsoleID!, consoleType: consoleType, completion: { (didSucceed) in
                        if didSucceed == true {
                            self.showSuccessFor(consoleName, consoleID: playerConsoleID!)
                        }
                    })
                }
            }
        }
    }
    
    func showSuccessFor (consoleType: String, consoleID: String) {
        
        let messageString = "Your \(consoleType) \(consoleID) has been added to your account."
        self.displayAlertWithTitleAndMessageAnOK("Success!", message: messageString) { (complete) in
            if complete == true {
                self.dismissViewController(true, dismissed: { (didDismiss) in
                    
                })
            }
        }
    }
    
    @IBAction func doneButtonPressed (sender: UIButton) {
        if self.consoleIDTextField?.text?.isEmpty == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter Bungie.net game tag")
            return
        }
        
        var selectedConsole = ""
        switch self.selectedIndex + 1 {
        case 1:
            selectedConsole = ConsoleTypes.PS4
            break
        case 2:
            selectedConsole = ConsoleTypes.PS3
            break
        case 3:
            selectedConsole = ConsoleTypes.XBOX360
            break

        default:
            selectedConsole = ConsoleTypes.XBOXONE
            break
        }
        
        _ = TRBungieUserAuthRequest().verifyBungieUserName((self.consoleIDTextField?.text!)!, consoleType: selectedConsole, completion: { (didSucceed) in
            if didSucceed == true {
                let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let verifyAccountViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_SIGNUP) as! TRCreateAccountViewController
                self.navigationController?.pushViewController(verifyAccountViewController, animated: true)
            }
        })
    }

    @IBAction func closeAddConsoleView (sender: UIButton) {
        
        if self.consoleIDTextField.isFirstResponder() {
            self.consoleIDTextField.resignFirstResponder()
        }
        
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }
    
    @IBAction func closePickerView(recognizer : UITapGestureRecognizer) {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.consolePickerView?.alpha = 0
            self.addConsolePlaceholderText()
        }
    }
    
    func addConsolePlaceholderText () {
        if let consoleType = self.consoleNameArray.objectAtIndex(self.selectedIndex) as? String {
            self.chooseConsoleButton?.titleLabel?.text = consoleType
            
            if consoleType == "PlayStation 4" || consoleType == "PlayStation 3" {
                self.consoleIDTextField.enabled = true
                self.consoleTypeLabel.text = "PLAYSTATION ID"
                self.consoleIDTextField.attributedPlaceholder = NSAttributedString(string:"Enter PlayStation ID", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
                self.consoleImage.image = UIImage(named: "iconPsnConsole")
                
                if self.openedFromProfile == true {
                    if let consoles = TRApplicationManager.sharedInstance.currentUser?.consoles {
                        for console in consoles {
                            if console.consoleType == ConsoleTypes.PS3 || console.consoleType == ConsoleTypes.PS4 {
                                if let consoleID = console.consoleId {
                                    self.consoleIDTextField.attributedPlaceholder = NSAttributedString(string:consoleID, attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
                                    self.consoleIDTextField.enabled = false
                                    self.preSelectedConsoleID = consoleID
                                    self.consoleTagView.hidden = true
                                    self.addUpdateNewConsole.setTitle("UPGRADE", forState: .Normal)
                                    self.upgradeLabel.hidden = false
                                    self.upgradeLabel.text = "NOTE: Once you upgrade to Playstation 4 you will no longer be able to view activities from Playstation 3."
                                    self.isUpgrade = true

                                    break
                                }
                            } else {
                                self.consoleIDTextField.attributedPlaceholder = NSAttributedString(string:"Enter PlayStation ID", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
                                self.preSelectedConsoleID = nil
                                self.consoleTagView.hidden = false
                                self.addUpdateNewConsole.setTitle("ADD", forState: .Normal)
                                self.upgradeLabel.hidden = true
                                self.isUpgrade = false
                            }
                        }
                    }
                }
            } else {
                self.consoleTypeLabel.text = "XBOX GAMERTAG"
                self.consoleIDTextField.enabled = true
                self.consoleIDTextField.attributedPlaceholder = NSAttributedString(string:"Enter Xbox Gamertag", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
                self.consoleImage.image = UIImage(named: "iconXboxoneConsole")
                
                if self.openedFromProfile == true {
                    if let consoles = TRApplicationManager.sharedInstance.currentUser?.consoles {
                        for console in consoles {
                            if console.consoleType == ConsoleTypes.XBOXONE || console.consoleType == ConsoleTypes.XBOX360 {
                                if let consoleID = console.consoleId {
                                    self.consoleIDTextField.attributedPlaceholder = NSAttributedString(string:consoleID, attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
                                    self.consoleIDTextField.enabled = false
                                    self.preSelectedConsoleID = consoleID
                                    self.consoleTagView.hidden = true
                                    self.addUpdateNewConsole.setTitle("UPGRADE", forState: .Normal)
                                    self.upgradeLabel.hidden = false
                                    self.upgradeLabel.text = "NOTE: Once you upgrade to xBox One you will no longer be able to view activities from xBox 360."
                                    self.isUpgrade = true
                                    
                                    break
                                }
                            } else {
                                self.consoleIDTextField.attributedPlaceholder = NSAttributedString(string:"Enter Xbox Gamertag", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
                                self.preSelectedConsoleID = nil
                                self.consoleTagView.hidden = false
                                self.addUpdateNewConsole.setTitle("ADD", forState: .Normal)
                                self.upgradeLabel.hidden = true
                                self.isUpgrade = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func openPickerView (sender: UIButton) {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.consolePickerView?.alpha = 1
        }
    }
    
    //#MARK:- KEYBOARD NOTIFICATIONS
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
        self.selectedIndex = row
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
