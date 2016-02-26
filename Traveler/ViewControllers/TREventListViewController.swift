//
//  TREventListViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TREventListViewController: TRBaseViewController {
    
    @IBOutlet var segmentControl: UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentControl?.removeBorders()
      
        let boldFont = UIFont(name: "Helvetica-Bold", size: 16.0)
        let boldTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : boldFont!,
        ]
        self.segmentControl!.setTitleTextAttributes(boldTextAttributes, forState: .Normal)
        self.segmentControl!.setTitleTextAttributes(boldTextAttributes, forState: .Selected)
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
    
    
    @IBAction func segmentControlSelection (sender: UISegmentedControl) {
        print("\(sender.selectedSegmentIndex)")
    }
    
    
    deinit {
        self.appManager.log.debug("de-init")
    }
    
    
    /*
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
    */
}
