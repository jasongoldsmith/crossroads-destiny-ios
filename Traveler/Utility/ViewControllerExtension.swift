//
//  ViewControllerExtension.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/22/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

extension UIViewController {
    
    typealias TRActivityIndicatorCompletion = (complete: Bool?) -> ()
    
    func displayAlertWithTitle(title: String, complete: TRActivityIndicatorCompletion)
    {
        let alertView = UIAlertController(title: title, message: " ", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                complete(complete: true)
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
}
