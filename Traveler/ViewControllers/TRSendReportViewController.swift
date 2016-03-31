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
        
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        nav?.barTintColor = UIColor(red: 10/255, green: 31/255, blue: 39/255, alpha: 1)

        //Adding Back Button to nav Bar
        let leftButton = UIButton(frame: CGRectMake(0,0,30,30))
        leftButton.setImage(UIImage(named: "iconBackArrow"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(TRCreateEventSelectionViewController.navBackButtonPressed(_:)), forControlEvents: .TouchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = leftButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func navBackButtonPressed (sender: UIBarButtonItem) {
        self.dismissViewController(true, dismissed: { (didDismiss) in
            self.didMoveToParentViewController(nil)
            self.removeFromParentViewController()
        })
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
