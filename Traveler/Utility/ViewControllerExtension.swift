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
    
    
    func addNavigationBarButtons () {
        
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        nav?.barTintColor = UIColor(red: 10/255, green: 31/255, blue: 39/255, alpha: 1)

        //Adding Back Button to nav Bar
        let leftButton = UIButton(frame: CGRectMake(0,0,44,44))
        leftButton.setImage(UIImage(named: "iconBackArrow"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(TRCreateEventViewController.navBackButtonPressed(_:)), forControlEvents: .TouchUpInside)
        leftButton.transform = CGAffineTransformMakeTranslation(-10, 0)
        
        // Add the button to a container, otherwise the transform will be ignored
        let leftButtonContainer = UIView(frame: leftButton.frame)
        leftButtonContainer.addSubview(leftButton)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = leftButtonContainer
        
//        // Avator Image View
//        if let imageString = TRUserInfo.getUserImageString() {
//            let imageUrl = NSURL(string: imageString)
//            let avatorImageView = UIImageView()
//            avatorImageView.sd_setImageWithURL(imageUrl)
//            let avatorImageFrame = CGRectMake((self.navigationController?.navigationBar.frame.width)! - avatorImageView.frame.size.width - 50, (self.navigationController?.navigationBar.frame.height)! - avatorImageView.frame.size.height - 40, 30, 30)
//            avatorImageView.frame = avatorImageFrame
//            avatorImageView.roundRectView()
//            
//            self.navigationController?.navigationBar.addSubview(avatorImageView)
//        }
        
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func hideNavigationBar () {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
