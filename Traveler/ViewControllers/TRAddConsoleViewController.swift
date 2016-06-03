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
    @IBOutlet weak var bungieIDTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var consolePicker: UIPickerView!
    @IBOutlet weak var consolePickerView: UIView!
    
    
    var consoleNameArray: NSArray = ["PlayStation 4","PlayStation 3", "Xbox 360", "Xbox One"]
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add radius to button edges
        self.chooseConsoleButton?.layer.cornerRadius = 3.0
        
        // Placeholder text color
        self.bungieIDTextField.attributedPlaceholder = NSAttributedString(string:"Enter your gamer tag", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        //Update Legal Text
        self.addLegalStatmentText()
        
        //PickerView
        self.consolePicker?.layer.cornerRadius = 5.0
        self.consolePicker?.layer.masksToBounds = true
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
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
        legalViewController.linkToOpen = url
        self.presentViewController(legalViewController, animated: true, completion: {
            
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.bungieIDTextField?.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldDidDidUpdate (textField: UITextField) {
        if self.bungieIDTextField?.text?.characters.count > 4 {
            self.nextButton?.enabled = true
            self.nextButton.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        } else {
            self.nextButton.enabled = false
            self.nextButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
        }
    }
    
    @IBAction func doneButtonPressed (sender: UIButton) {
        if self.bungieIDTextField?.text?.isEmpty == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter Bungie.net game tag")
            return
        }
        
        var selectedConsole = ""
        switch self.selectedIndex {
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
        
        _ = TRBungieUserAuthRequest().verifyBungieUserName((self.bungieIDTextField?.text!)!, consoleType: selectedConsole, completion: { (didSucceed) in
            if didSucceed == true {
            }
        })
    }

    
    @IBAction func closePickerView(recognizer : UITapGestureRecognizer) {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.consolePickerView?.alpha = 0
        }
    }
    
    @IBAction func openPickerView (sender: UIButton) {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.consolePickerView?.alpha = 1
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

    deinit {
        
    }
}