//
//  AppDelegate.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import Branch
import Mixpanel
import FBSDKCoreKit
import Answers
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        
        //Initializing Manager
        TRApplicationManager.sharedInstance
        
        //Initialize FireBase Configuration
        TRApplicationManager.sharedInstance.fireBaseManager?.initFireBaseConfig()
        
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary? {
            let rootViewController = self.window!.rootViewController as! TRRootViewController
            rootViewController.pushNotificationData = remoteNotification
        }

        //Local Notifications
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS8"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        
        //Status Bar 
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        
        //MixedPanel Initialized
        let token = "23f27698695b0137adfef97f173b9f91"
        Mixpanel.initialize(token: token)
        

        //Initialize Answers
        Fabric.with([Branch.self, Answers.self])

        
        //Facebook Init
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        
        //Branch Initialized
        let branch: Branch = Branch.getInstance()
        branch.initSessionWithLaunchOptions(launchOptions, andRegisterDeepLinkHandler: { params, error in
            // route the user based on what's in params
            
            // Tracking Open Source
            var mySourceDict = [String: AnyObject]()
            mySourceDict["source"] = K.SharingPlatformType.Platform_Branch
            _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(mySourceDict, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_INIT)
            
            
            if let isBranchLink = params["+clicked_branch_link"]?.boolValue where  isBranchLink == true {
                if let isFirstSession = params["+is_first_session"]?.boolValue where  isFirstSession == true {
                    let branchUrl: NSURL = NSURL(string: "branch")!
                    let deepLinkObj = TRDeepLinkObject(link: branchUrl)
                    let deepLinkAnalyticsDict = deepLinkObj.createLinkInfoAndPassToBackEnd()
                    if let _ = deepLinkAnalyticsDict {
                        self.appInstallRequestWithDict(deepLinkAnalyticsDict!)
                    }
                    do {
                        let _ = try TRKeyChainHelper.updateData(K.SharingPlatformType.Platform_Branch, itemValue: "true")
                    } catch _ as KeychainError {
                        
                    } catch {
                    }
                } else {
                    var mySourceDict = [String: AnyObject]()
                    mySourceDict["source"] = K.SharingPlatformType.Platform_Branch
                    self.appInitializedRequest(mySourceDict)
                }
                
                let eventID = params["eventId"] as? String
                let activityName = params["activityName"] as? String
                
                guard let _ = eventID else {
                    return
                }

                TRApplicationManager.sharedInstance.addPostActionbranchDeepLink(eventID!, activityName: activityName!, params: params)
            }
        })
        

//        do {
//            let _ = try TRKeyChainHelper.deleteData(K.SharingPlatformType.Platform_Branch)
//            let _ = try TRKeyChainHelper.deleteData(K.SharingPlatformType.Platform_Facebook)
//        } catch _ as KeychainError {
//            
//        } catch {
//        }

        
        // App Initialized Metrics
        var mySourceDict = [String: AnyObject]()
        mySourceDict["source"] = K.SharingPlatformType.Platform_UnKnown
        self.appInitializedRequest(mySourceDict)
        
        // App Install Metrics
        self.appInstallInfoSequence(mySourceDict)
        
        return true
    }

    // MARK:- Branch Deep Linking related methods
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if (Branch.getInstance().handleDeepLink(url)) {
            var mySourceDict = [String: AnyObject]()
            mySourceDict["source"] = K.SharingPlatformType.Platform_Branch
            self.appInitializedRequest(mySourceDict)
        }

        FBSDKAppLinkUtility.fetchDeferredAppLink({ (URL, error) -> Void in
            if error != nil {
            }
            if URL != nil {
                
                let deepLinkObj = TRDeepLinkObject(link: URL)
                let deepLinkAnalyticsDict = deepLinkObj.createLinkInfoAndPassToBackEnd()
                if let _ = deepLinkAnalyticsDict {
                    self.appInstallInfoSequence(deepLinkAnalyticsDict!)
                }
                do {
                    let _ = try TRKeyChainHelper.updateData(K.SharingPlatformType.Platform_Facebook, itemValue: "true")
                } catch _ as KeychainError {
                    
                } catch {
                }
            }
        })
        
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        Branch.getInstance().continueUserActivity(userActivity);
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            //let url = userActivity.webpageURL!
        }
        
        return true
    }

    
    // MARK:- Notifications
    func addNotificationsPermission () {
        if UIApplication.sharedApplication().respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
            
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: [])
            
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        for i in 0 ..< deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
       
        _ = TRDeviceTokenRequest().sendDeviceToken(tokenString, completion: { (value) -> () in
            if (value == true) {
                print("Device token registration Success")
            } else {
                print("Device token registration failed")
            }
        })
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
       
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {

        if application.applicationState == UIApplicationState.Active {
            NSNotificationCenter.defaultCenter().postNotificationName(K.NOTIFICATION_TYPE.REMOTE_NOTIFICATION_WITH_ACTIVE_SESSION, object: self, userInfo: userInfo)
        }
        if application.applicationState != UIApplicationState.Active {
            NSNotificationCenter.defaultCenter().postNotificationName(K.NOTIFICATION_TYPE.APPLICATION_DID_RECEIVE_REMOTE_NOTIFICATION, object: self, userInfo: userInfo)
        }
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        
        // Tracking App Init
        var mySourceDict = [String: AnyObject]()
        mySourceDict["source"] = K.SharingPlatformType.Platform_UnKnown
        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(mySourceDict, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_INIT)

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //MARK:- App Data Requests
    func appInitializedRequest (initInfo: Dictionary<String, AnyObject>) {
        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(initInfo, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_INIT)
    }
    
    func appInstallRequestWithDict (installInfo: Dictionary<String, AnyObject>) {
        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(installInfo, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_INSTALL)
    }
    
    func appInstallInfoSequence (installInfo: Dictionary<String, AnyObject>) {
        do {
            let isBranchInstall = try TRKeyChainHelper.queryData(K.SharingPlatformType.Platform_Branch)
            let isFaceBookInstall = try TRKeyChainHelper.queryData(K.SharingPlatformType.Platform_Facebook)
            
            if isBranchInstall!.boolValue == true || isFaceBookInstall!.boolValue == true {
                return
            } else {
                self.appInstallRequestWithDict(installInfo)
            }
            
        } catch KeychainError.ItemNotFound {
            
            //Send Install Info, this will be overwritten if FaceBook's deferred link is called or if Branch's call back gets called
            self.appInstallRequestWithDict(installInfo)
            
            do {
                let _ = try TRKeyChainHelper.addData(K.SharingPlatformType.Platform_Branch, itemValue: "false")
                let _ = try TRKeyChainHelper.addData(K.SharingPlatformType.Platform_Facebook, itemValue: "false")
            } catch _ as KeychainError {
                
            } catch {
            }
        } catch {
            print("catch")
        }
    }
}

