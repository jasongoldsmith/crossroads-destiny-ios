//
//  TRRootViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit


class TRRootViewController: TRBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated)
        if (TRUserInfo.isUserLoggedIn()) {
            
            //Sending Request to fetch the Events List and OnSuccess loading the TREventListViewController ViewController
            _ = TRGetEventsList().getEventsList({ (value) -> () in
                if(value == true) {
                    self.performSegueWithIdentifier("TREventListView", sender: self)
                    self.appManager.log.debug("Success")
                    
                } else {
                    self.appManager.log.debug("Failed")
                }
            })
            

//            _ = TRCreateEventRequest().createAnEvent({ (value) -> () in
//                if(value == true) {
//                    self.performSegueWithIdentifier("TREventListView", sender: self)
//                    self.appManager.log.debug("Success")
//                    
//                } else {
//                    self.appManager.log.debug("Failed")
//                }
//            })
            
        }
        else {
            self.performSegueWithIdentifier("TRLoginOptionView", sender: self)
        }
    }
    
    @IBAction func trUnwindAction(segue: UIStoryboardSegue) {
        
    }


}

