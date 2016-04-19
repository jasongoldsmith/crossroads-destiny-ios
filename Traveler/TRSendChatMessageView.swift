//
//  TRSendChatMessageView.swift
//  Traveler
//
//  Created by Manjunatha, Roopesh on 3/30/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import pop

class TRSendChatMessageView: UIView, UITextFieldDelegate {
    
    private let MAX_MESSAGE_CHARACTER_COUNT = 140
    
    @IBOutlet weak var sendToLabel: UILabel!
    @IBOutlet weak var chatBubbleTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var characterCount: UILabel!
    
    var userId:String!
    var eventId:String!
    var sendToAll: Bool?
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.chatBubbleTextField.delegate = self
        self.chatBubbleTextField.layer.cornerRadius = self.chatBubbleTextField.frame.height * 0.5
        self.sendButton?.addTarget(self, action: #selector(TRSendChatMessageView.sendChatMessage(_:)), forControlEvents: .TouchUpInside)
        self.chatBubbleTextField.becomeFirstResponder()
        
        // Close View on Clicking BackGround Image View
        self.addCloseToBackGroundImageView()
    }
    
    func addCloseToBackGroundImageView () {
        let closeViewGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TRSendChatMessageView.closeView))
        self.backGroundImageView?.userInteractionEnabled = true
        self.backGroundImageView?.addGestureRecognizer(closeViewGestureRecognizer)
    }
    
    
    func closeView()  {

        if self.chatBubbleTextField.isFirstResponder() {
            self.chatBubbleTextField.resignFirstResponder()
        }

        let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        popAnimation.toValue = 0.0
        popAnimation.duration = 0.2
        popAnimation.completionBlock = {(animation, finished) in
            self.removeFromSuperview()
        }
        
        self.pop_addAnimation(popAnimation, forKey: "alphasIn")
    }
    
// Mark: UITextFieldDelegate methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = MAX_MESSAGE_CHARACTER_COUNT - (textField.text?.characters.count)!
        self.characterCount.text = "\(newLength)"
        
        if (newLength <= 0) {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Message limit reached.")
            
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        self.chatBubbleTextField.becomeFirstResponder()
    }
    
    func sendChatMessage(sender: EventButton) {
        
        
        let message: String = (self.chatBubbleTextField?.text)!
        if (message.characters.count == 0) {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a message.")
            return
        }
        
        if let sendAll = sendToAll {
            if sendAll {
                _ = TRSendPushMessage().sendPushMessageToAll(self.eventId, messageString: message, completion: { (didSucceed) in
                    if (didSucceed != nil)  {
                        self.chatBubbleTextField.resignFirstResponder()
                        self.chatBubbleTextField.text = nil
                        self.removeFromSuperview()
                    } else {
                        self.chatBubbleTextField.becomeFirstResponder()
                    }
                })
            } else {
                _ = TRSendPushMessage().sendPushMessageTo(self.userId, eventId: self.eventId, messageString: message, completion: { (didSucceed) in
                    if (didSucceed != nil)  {
                        self.chatBubbleTextField.resignFirstResponder()
                        self.chatBubbleTextField.text = nil
                        self.removeFromSuperview()
                    } else {
                        self.chatBubbleTextField.becomeFirstResponder()
                    }
                })
            }
        }
    }
}

