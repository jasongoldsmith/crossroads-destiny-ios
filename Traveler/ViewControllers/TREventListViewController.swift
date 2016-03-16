//
//  TREventListViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import Foundation


private let CURRENT_EVENT_CELL = "currentEventCell"
private let EVENT_TABLE_HEADER_HEIGHT:CGFloat = 10.0


class TREventListViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var segmentControl: UISegmentedControl?
    @IBOutlet var eventsTableView: UITableView?
    @IBOutlet var segmentOneUnderLine: UIImageView?
    @IBOutlet var segmentTwoUnderLine: UIImageView?
    @IBOutlet var currentPlayerAvatorIcon: UIImageView?
    
    //Events Information
    var eventsInfo: [TREventInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentControl?.removeBorders()
      
        let boldFont = UIFont(name: "Helvetica-Bold", size: 16.0)
        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : boldFont!,
        ]
        
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, forState: .Normal)
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, forState: .Selected)
        
    
        self.eventsTableView?.registerNib(UINib(nibName: "TREventTableCellView", bundle: nil), forCellReuseIdentifier: CURRENT_EVENT_CELL)
        self.eventsTableView?.tableFooterView = UIView(frame: CGRectZero)
        
        //Adding Radius to the Current Player Avator
        self.currentPlayerAvatorIcon?.layer.cornerRadius = (self.currentPlayerAvatorIcon?.frame.width)!/2

        //Avator for Current Player
        if let imageUrl = TRUserInfo.getUserImageString() {
            let imageUrl = NSURL(string: imageUrl)
            self.currentPlayerAvatorIcon?.sd_setImageWithURL(imageUrl)
            TRApplicationManager.sharedInstance.imageHelper.roundImageView(self.currentPlayerAvatorIcon!)
            
            // Add LogOut event action to Avator Image
            self.addLogOutEventToAvatorImageView()
        }
        
        // Notification Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveRemoteNotificationInActiveSesion:", name: "RemoteNotificationWithActiveSesion", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveRemoteNotificationInActiveSesion:", name: "UIApplicationDidReceiveRemoteNotification", object: nil)
    }

    func addLogOutEventToAvatorImageView () {
        let logOutGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("logoutBtnTapped:"))
        self.currentPlayerAvatorIcon?.userInteractionEnabled = true
        self.currentPlayerAvatorIcon?.addGestureRecognizer(logOutGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadEventTable()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        
        return EVENT_TABLE_HEADER_HEIGHT
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.eventsInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CURRENT_EVENT_CELL) as! TREventTableCellView
        
        if segmentControl?.selectedSegmentIndex == 0 {
            cell.updateCellViewWithEvent(eventsInfo[indexPath.section])
        } else {
            cell.updateCellViewWithEvent(eventsInfo[indexPath.section])
        }

        cell.joinEventButton?.addTarget(self, action: "joinAnEvent:", forControlEvents: .TouchUpInside)
        cell.joinEventButton?.buttonEventInfo = eventsInfo[indexPath.section]

        cell.leaveEventButton?.addTarget(self, action: "leaveAnEvent:", forControlEvents: .TouchUpInside)
        cell.leaveEventButton.buttonEventInfo = eventsInfo[indexPath.section]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.eventsTableView?.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func joinAnEvent (sender: EventButton) {
      
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            TRApplicationManager.sharedInstance.activityIndicator.startActivityIndicator(self)
        }
        
        if let eventInfo = sender.buttonEventInfo {
            _ = TRJoinEventRequest().joinEventWithUserForEvent(TRUserInfo.getUserID()!, eventInfo: eventInfo, completion: { (value) -> () in
                if (value == true) {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        TRApplicationManager.sharedInstance.activityIndicator.stopActivityIndicator()
                        self.reloadEventTable()
                    }
                } else {
                    print("Failed")
                }
            })
        }
    }
    
    func leaveAnEvent (sender: EventButton) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            TRApplicationManager.sharedInstance.activityIndicator.startActivityIndicator(self)
        }

        _ = TRLeaveEventRequest().leaveAnEvent(sender.buttonEventInfo!,completion: {value in
            if (value == true) {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    TRApplicationManager.sharedInstance.activityIndicator.stopActivityIndicator()
                    self.reloadEventTable()
                }
            } else {
                
            }
        })
    }
    
    @IBAction func createAnEvent () {
        
        //Start Activity Indicator
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            TRApplicationManager.sharedInstance.activityIndicator.startActivityIndicator(self)
        }
        
        
        _ = TRgetActivityList().getActivityList({ (value) -> () in
            if (value == true) {
                
                //Stop Activity Indicator
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    TRApplicationManager.sharedInstance.activityIndicator.stopActivityIndicator()
                })
                

                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : TRCreateEventViewController = storyboard.instantiateViewControllerWithIdentifier(K.ViewControllerIdenifier.VIEWCONTROLLER_CREATE_EVENT) as! TRCreateEventViewController
                let navigationController = UINavigationController(rootViewController: vc)
                self.presentViewController(navigationController, animated: true, completion: nil)
            } else {
                self.appManager.log.debug("Activity List fetch failed")
            }
        })
    }
    
    func reloadEventTable () {
        
        //Reload Table
        self.eventsInfo = TRApplicationManager.sharedInstance.eventsList
        self.eventsTableView?.reloadData()
    }
    
    @IBAction func segmentControlSelection (sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.segmentOneUnderLine?.hidden = false
            self.segmentTwoUnderLine?.hidden = true
            break;
        case 1:
            self.segmentOneUnderLine?.hidden = true
            self.segmentTwoUnderLine?.hidden = false
            break;
        default:
            break;
        }
        
        //Reload Data
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.reloadEventTable()
        }
    }
    
    
    func logoutBtnTapped(sender: AnyObject) {
        let createRequest = TRAuthenticationRequest()
        createRequest.logoutTRUser() { (value ) in  //, errorData) in
            if value == true {
                TRUserInfo.removeUserData()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else
            {
                self.displayAlertWithTitle("Logout Failed", complete: { (complete) -> () in
                    
                })
            }
        }
    }

    func didReceiveRemoteNotificationInActiveSesion(sender: NSNotification) {
        self.displayAlertWithTitle("Event Notification Received", complete: { (complete) -> () in
            
        })
    }

    
    deinit {
        self.appManager.log.debug("de-init")
    }
}
