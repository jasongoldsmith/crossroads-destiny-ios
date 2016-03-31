//
//  TRSendReportViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/31/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


class TRSendReportViewController: TRBaseViewController {
    
    @IBOutlet weak var reportTextView: UITextView?
    
    override func viewDidLoad() {
         super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func sendReportButtonAdded (sender: AnyObject) {
        
        let currentUserID = TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()
        
        let textString: String = (self.reportTextView?.text)!
        
        if (textString.characters.count == 0) {
            
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Empty report message!")
            return
        }
        
        _ = TRCreateAReportRequest().sendCreatedReport((self.reportTextView?.text)!, reportType: "issue", reporterID: (currentUserID?.playerID)!, completion: { (didSucceed) in
            if (didSucceed != nil)  {
                self.displayAlertWithTitle("Report Send", complete: { (complete) in
                    self.dismissViewController(true, dismissed: { (didDismiss) in
                        self.didMoveToParentViewController(nil)
                        self.removeFromParentViewController()
                    })
                })
            } else {
                
            }
        })
    }
}
