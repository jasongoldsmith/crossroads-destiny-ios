//
//  TRLoginOptionViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRLoginOptionViewController: TRBaseViewController {
    
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

        if let _ = TRUserInfo.getbungieAccount() where TRUserInfo.isUserVerified() == false {
            self.performSegueWithIdentifier("TRCreateAccountView", sender: self)
        }
    }
    
    @IBAction func createAccountBtnTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("TRAddConsoleView", sender: self)
    }
    
    @IBAction func signIntBtnTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("TRSignInView", sender: self)
    }
    
    @IBAction func trUnwindActionToLoginOption(segue: UIStoryboardSegue) {
        
    }
}
