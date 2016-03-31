//
//  TRRootViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift


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
            _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, indicatorTopConstraint: ACTIVITY_INDICATOR_TOP_CONSTRAINT, completion: { (didSucceed) -> () in
                if(didSucceed == true) {
                    TRApplicationManager.sharedInstance.addSlideMenuController(self)
//                    self.performSegueWithIdentifier("TREventListView", sender: self)
                } else {
                    self.appManager.log.debug("Failed")
                }
            })
        } else {
            self.performSegueWithIdentifier("TRLoginOptionView", sender: self)
        }
    }

    @IBAction func trUnwindAction(segue: UIStoryboardSegue) {
        
    }
}

