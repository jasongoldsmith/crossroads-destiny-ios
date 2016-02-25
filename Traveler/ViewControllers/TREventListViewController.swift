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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}
