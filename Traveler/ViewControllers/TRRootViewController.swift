//
//  TRRootViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit


class TRRootViewController: TRBaseViewController {

    
    private let ACTIVITY_INDICATOR_TOP_CONSTRAINT: CGFloat = 365.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated)
        
        if (TRUserInfo.isUserLoggedIn()) {
            
            // Add Activity Indicator
            TRApplicationManager.sharedInstance.activityIndicator.startActivityIndicator(self, withClearBackGround: true, activityTopConstraintValue: ACTIVITY_INDICATOR_TOP_CONSTRAINT)
            
            //Sending Request to fetch the Events List and OnSuccess loading the TREventListViewController ViewController
            _ = TRGetEventsList().getEventsList({ (value) -> () in
                if(value == true) {
                    
                    // Stop Activity Indicator
                    TRApplicationManager.sharedInstance.activityIndicator.stopActivityIndicator()

                    self.performSegueWithIdentifier("TREventListView", sender: self)
                    
                } else {
                    self.appManager.log.debug("Failed")
                }
            })
        }
        else {
            self.performSegueWithIdentifier("TRLoginOptionView", sender: self)
        }
    }
    
    @IBAction func trUnwindAction(segue: UIStoryboardSegue) {
        
    }
}

