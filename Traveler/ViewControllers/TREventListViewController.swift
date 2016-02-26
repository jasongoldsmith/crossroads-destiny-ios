//
//  TREventListViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TREventListViewController: TRBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutBtnTapped(sender: AnyObject) {
        
        let createRequest = TRAuthenticationRequest()
        createRequest.logoutTRUser() { (value ) in  //, errorData) in
            if value == true {
                
                TRUserInfo.removeUserData()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else
            {
                self.displayAlertWithTitle("Logout Failed")
            }
        }
        
    }
    
    deinit {
        self.appManager.log.debug("de-init")
    }
    
}
