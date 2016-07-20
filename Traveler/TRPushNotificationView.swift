//
//  TRPushNotificationView.swift
//  Traveler
//
//  Created by Ashutosh on 3/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRPushNotificationView: UIView {
    
    @IBOutlet weak var eventStatusLabel: UILabel!
    @IBOutlet weak var eventStatusDescription: TRAlignableUILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func closeErrorView (sender: AnyObject) {
        self.removeFromSuperview()
    }

    
    func addNotificationViewWithMessages (sender: NSNotification) -> TRPushNotificationView {

        let pushInfo = TRActiveStatePushInfo().parsePushNotificationPayLoad(sender)
        
//        if self.superview != nil {
//            self.removeFromSuperview()
//        }
//
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let window = appDelegate.window
//
//        let xAxiDistance:CGFloat  = 0
//        let yAxisDistance:CGFloat = 130
//        self.frame = CGRectMake(xAxiDistance, yAxisDistance, window!.frame.width, self.frame.height)
//        
//        if let userInfo = sender.userInfo as NSDictionary? {
//            if let payload = userInfo.objectForKey("payload") as? NSDictionary {
//                if let notificationType = payload.objectForKey("notificationName") as? String where notificationType == NOTIFICATION_NAME.NOTI_MESSAGE_PLAYER.rawValue {
//                    if let apsData = userInfo.objectForKey("aps") as? NSDictionary {
//                        self.eventStatusLabel.text =  "FIRETEAM MESSAGE"
//                        if let alertString = apsData.objectForKey("alert") as? String {
//                            if let eventType = payload.objectForKey("eventName") as? String {
//                                let messageString = eventType.uppercaseString + "\n" + alertString
//                                self.eventStatusDescription.text = messageString
//                            } else {
//                                self.eventStatusDescription.text =  alertString
//                            }
//                        }
//                    }
//                } else {
//                    if let eventType = payload.objectForKey("eventName") as? String {
//                        self.eventStatusLabel.text = eventType.uppercaseString
//                    }
//                    if let apsData = userInfo.objectForKey("aps") as? NSDictionary {
//                        self.eventStatusDescription.text =  apsData.objectForKey("alert") as? String
//                    }
//                }
//            }
//        }
        
        return self
    }
}