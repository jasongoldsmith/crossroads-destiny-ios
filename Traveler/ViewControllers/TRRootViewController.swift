//
//  TRRootViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRRootViewController: UIViewController {

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
            self.performSegueWithIdentifier("TREventListView", sender: self)
            
        }
        else {
            self.performSegueWithIdentifier("TRLoginOptionView", sender: self)
        }
    }
    
    @IBAction func trUnwindAction(segue: UIStoryboardSegue) {
        
    }


}

