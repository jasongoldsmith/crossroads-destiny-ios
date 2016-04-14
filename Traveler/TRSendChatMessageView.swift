//
//  TRSendChatMessageView.swift
//  Traveler
//
//  Created by Manjunatha, Roopesh on 3/30/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRSendChatMessageView: UIView, UITextFieldDelegate {
    
    
    @IBOutlet weak var sendToLabel: UILabel!
    @IBOutlet weak var chatBubbleTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var userId:String!
    var eventId:String!
    var sendToAll: Bool?
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.chatBubbleTextField.delegate = self
        self.chatBubbleTextField.layer.cornerRadius = self.chatBubbleTextField.frame.height * 0.5
        self.sendButton?.addTarget(self, action: #selector(TRSendChatMessageView.sendChatMessage(_:)), forControlEvents: .TouchUpInside)
    }
    
// Mark: UITextFieldDelegate methods
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField)
    {
        self.chatBubbleTextField.becomeFirstResponder()
    }
    
    func sendChatMessage(sender: EventButton) {
        
        
        let message: String = (self.chatBubbleTextField?.text)!
        if (message.characters.count == 0) {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Empty report message!")
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

