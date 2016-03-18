//
//  TRBaseViewController.swift
//  Traveler
//
//  Created by Ashutosh on 2/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRBaseViewController: UIViewController {
    
    var currentViewController: UIViewController?
    let appManager  = TRApplicationManager.sharedInstance
    let defaults    = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Add app state observers
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationWillEnterForeground",
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "applicationDidEnterBackground",
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
        
        // Notification Observer
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "didReceiveRemoteNotificationInActiveSesion:",
            name: "RemoteNotificationWithActiveSesion",
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "didReceiveRemoteNotificationInActiveSesion:",
            name: "UIApplicationDidReceiveRemoteNotification",
            object: nil)

        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        self.currentViewController = self
        
        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.currentViewController = nil
        
        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        
        guard  let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
            return
        }
        
        statusBar.backgroundColor = color
    }

    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func applicationWillEnterForeground() {
        appManager.log.debug("applicationWillEnterForeground")
    }
    
    func applicationDidEnterBackground() {
        appManager.log.debug("applicationDidEnterBackground")
    }
    
    func didReceiveRemoteNotificationInActiveSesion(sender: NSNotification) {
        self.view.addSubview(TRApplicationManager.sharedInstance.addNotificationViewWithMessages(self, sender: sender))
    }

    
    deinit {
        
        //Remove Observers
        NSNotificationCenter.defaultCenter().removeObserver(UIApplicationWillEnterForegroundNotification)
        NSNotificationCenter.defaultCenter().removeObserver(UIApplicationDidEnterBackgroundNotification)
        
        
        appManager.log.debug("\(NSStringFromClass(self.dynamicType))")
    }
}