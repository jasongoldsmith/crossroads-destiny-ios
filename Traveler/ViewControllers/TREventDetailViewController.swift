//
//  TREventDetailViewController.swift
//  Traveler
//
//  Created by Ashutosh on 8/16/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TREventDetailViewController: TRBaseViewController {
    
    //Current Event
    var eventInfo: TREventInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    //MARK:- IB_ACTIONS
    @IBAction func dismissButton (sender: UIButton) {
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }
    
    @IBAction func shareButton (sender: UIButton) {
        TRApplicationManager.sharedInstance.branchManager?.createLinkWithBranch(self.eventInfo!, deepLinkType: BRANCH_DEEP_LINKING_END_POINT.EVENT_DETAIL.rawValue, callback: {(url, error) in
            if (error == nil) {
                print(url)
                // Group to Share
                let groupToShare = [url!] as [AnyObject]
                
                let activityViewController = UIActivityViewController(activityItems: groupToShare , applicationActivities: nil)
                self.presentViewController(activityViewController, animated: true, completion: {})
            } else {
                print(String(format: "Branch TestBed: %@", error))
            }
        })
    }
    
    deinit {
        
    }
}