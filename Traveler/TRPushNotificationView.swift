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
    
    private let TIMER_INTERVAL: Double = 5
    
    @IBOutlet weak var eventStatusLabel: UILabel!
    @IBOutlet weak var eventStatusDescription: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func closeErrorView (sender: AnyObject) {
        self.removeFromSuperview()
    }

    
    func addNotificationViewWithMessages (parentView: TRBaseViewController, sender: NSNotification) -> TRPushNotificationView {
        
        let xAxiDistance:CGFloat  = 0
        let yAxisDistance:CGFloat = 130
        self.frame = CGRectMake(xAxiDistance, yAxisDistance, parentView.view.frame.width, self.frame.height)
        self.removeFromSuperview()
        
        if let userInfo = sender.userInfo as NSDictionary? {
            if let payload = userInfo.objectForKey("payload") as? NSDictionary {
                if let eType = payload.objectForKey("eType") as? NSDictionary {
                    if let eventType = eType.objectForKey("aType") as? String {
                        self.eventStatusDescription.text = eventType
                    }
                }
                if let _ = payload.objectForKey("playerMessage"){
                    if let apsData = userInfo.objectForKey("aps") as? NSDictionary {
                        self.eventStatusDescription.text =  apsData.objectForKey("alert") as? String
                        self.eventStatusLabel.text =  "Fireteam Message"
                        
                    }
                } else {
                    if let apsData = userInfo.objectForKey("aps") as? NSDictionary {
                        self.eventStatusLabel.text =  apsData.objectForKey("alert") as? String
                    }
                }
            }
        }
        
        delay(10) {
            self.removeFromSuperview()
        }
        
        return self
    }
}