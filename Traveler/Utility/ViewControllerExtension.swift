//
//  ViewControllerExtension.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/22/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayAlertWithTitle(title: String)
    {
        let alertView = UIAlertController(title: title, message: " ", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
}
