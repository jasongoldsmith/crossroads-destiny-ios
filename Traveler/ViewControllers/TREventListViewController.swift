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


class TREventListViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var segmentControl: UISegmentedControl?
    @IBOutlet var eventsTableView: UITableView?
    @IBOutlet var segmentOneUnderLine: UIImageView?
    @IBOutlet var segmentTwoUnderLine: UIImageView?
    @IBOutlet var currentPlayerAvatorIcon: UIImageView?
    
    //Events Information
    var eventsInfo: [TREventInfo] = []
    
    // Future Events Information
    var futureEventsInfo: [TREventInfo] = []
    
    // Pull to Refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TREventListViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
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
        self.eventsTableView?.addSubview(self.refreshControl)
        
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
        
        //Load table
        self.reloadEventTable()
    }

    func addLogOutEventToAvatorImageView () {
        let logOutGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TREventListViewController.logoutBtnTapped(_:)))
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
    
    
    override func applicationDidEnterBackground() {
    }
    
    override func applicationWillEnterForeground() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Table Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.eventsInfo.count > 0 else {
            return 0
        }
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
        
        guard self.eventsInfo.count > 0 else {
            return 0
        }
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            return self.eventsInfo.count
        }
        
        return self.futureEventsInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CURRENT_EVENT_CELL) as! TREventTableCellView
        
        if segmentControl?.selectedSegmentIndex == 0 {
            cell.updateCellViewWithEvent(self.eventsInfo[indexPath.section])
            cell.joinEventButton?.buttonEventInfo = eventsInfo[indexPath.section]
            cell.leaveEventButton.buttonEventInfo = eventsInfo[indexPath.section]
        } else {
            cell.updateCellViewWithEvent(self.futureEventsInfo[indexPath.section])
            cell.joinEventButton?.buttonEventInfo = futureEventsInfo[indexPath.section]
            cell.leaveEventButton.buttonEventInfo = futureEventsInfo[indexPath.section]
        }

        cell.joinEventButton?.addTarget(self, action: #selector(TREventListViewController.joinAnEvent(_:)), forControlEvents: .TouchUpInside)
        cell.leaveEventButton?.addTarget(self, action: #selector(TREventListViewController.leaveAnEvent(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.eventsTableView?.deselectRowAtIndexPath(indexPath, animated: false)
        
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TREventInformationViewController = storyboard.instantiateViewControllerWithIdentifier(K.ViewControllerIdenifier.VIEW_CONTROLLER_EVENT_INFORMATION) as! TREventInformationViewController
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            vc.eventInfo = self.eventsInfo[indexPath.section]
        } else {
            vc.eventInfo = self.futureEventsInfo[indexPath.section]
        }
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    //MARK:- Event Methods
    func joinAnEvent (sender: EventButton) {
      
        if let eventInfo = sender.buttonEventInfo {
            _ = TRJoinEventRequest().joinEventWithUserForEvent(TRUserInfo.getUserID()!, eventInfo: eventInfo, completion: { (value) -> () in
                if (value == true) {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.reloadEventTable()
                    }
                } else {
                    print("Failed")
                }
            })
        }
    }
    
    func leaveAnEvent (sender: EventButton) {
        
        _  = TRLeaveEventRequest().leaveAnEvent(sender.buttonEventInfo!,completion: {value in
            if (value == true) {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.reloadEventTable()
                }
            } else {
                
            }
        })
    }
    
    @IBAction func createAnEvent () {
        
        _ = TRgetActivityList().getActivityList({ (value) -> () in
            if (value == true) {
                
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : TRCreateEventViewController = storyboard.instantiateViewControllerWithIdentifier(K.ViewControllerIdenifier.VIEWCONTROLLER_CREATE_EVENT) as! TRCreateEventViewController
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.navigationBar.barStyle = .Black
                self.presentViewController(navigationController, animated: true, completion: nil)
            } else {
                self.appManager.log.debug("Activity List fetch failed")
            }
        })
    }
    
    //MARK:- Table Refresh
    func handleRefresh(refreshControl: UIRefreshControl) {

        _ = TRGetEventsList().getEventsListWithClearActivityBackGround(false, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
            if(didSucceed == true) {
                refreshControl.endRefreshing()
                delay(0.5, closure: {
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.reloadEventTable()
                    })
                })
            } else {
                self.appManager.log.debug("Failed")
            }
        })
    }
    
    
    func reloadEventTable () {
        
        //Reload Table
        self.eventsInfo       = TRApplicationManager.sharedInstance.getCurrentEvents()
        self.futureEventsInfo = TRApplicationManager.sharedInstance.getFutureEvents()
        
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
        TRApplicationManager.sharedInstance.slideMenuController.openRight()
    }

    deinit {
        self.eventsInfo.removeAll()
        self.futureEventsInfo.removeAll()
        
        self.appManager.log.debug("de-init")
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.eventsTableView!.numberOfSections
            let numberOfRows = self.eventsTableView!.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.eventsTableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
}
