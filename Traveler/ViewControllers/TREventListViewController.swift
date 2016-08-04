//
//  TREventListViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import SlideMenuControllerSwift

private let CURRENT_EVENT_WITH_CHECK_POINT_CELL     = "currentEventCellWithCheckPoint"
private let CURRENT_EVENT_NO_CHECK_POINT_CELL       = "currentEventCellNoCheckPoint"
private let UPCOMING_EVENT_WITH_CHECK_POINT_CELL    = "upcomingEventCellWithCheckPoint"
private let UPCOMING_EVENT_NO_CHECK_POINT_CELL      = "upcomingEventCellNoCheckPoint"
private let EVENT_ACTIVITY_CARD_CELL                = "eventActivityCard"

private let EVENT_TABLE_HEADER_HEIGHT:CGFloat = 10.0

private let EVENT_CURRENT_WITH_CHECK_POINT_CELL_HEIGHT: CGFloat  = 137.0
private let EVENT_CURRENT_NO_CHECK_POINT_CELL_HEIGHT:CGFloat     = 119.0
private let EVENT_UPCOMING_WITH_CHECK_POINT_CELL_HEIGHT:CGFloat  = 150.0
private let EVENT_UPCOMING_NO_CHECK_POINT_CELL_HEIGHT:CGFloat    = 137.0
private let EVENT_ACTIVITY_CELL_HEIGHT:CGFloat                   = 156.0

class TREventListViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate,ErrorViewProtocol {
    
    @IBOutlet var segmentControl: UISegmentedControl?
    @IBOutlet var eventsTableView: UITableView?
    @IBOutlet var segmentOneUnderLine: UIImageView?
    @IBOutlet var segmentTwoUnderLine: UIImageView?
    @IBOutlet var currentPlayerAvatorIcon: UIImageView?
    @IBOutlet var emptyTableBackGround: UIImageView?
    @IBOutlet var playerGroupsIcon: UIImageView?
    @IBOutlet var eventTableTopConstraint: NSLayoutConstraint?
    
    //Events Information
    var eventsInfo: [TREventInfo] = []
    
    //Activity Cards
    var activityCardsInfo: [TRActivityInfo] = []
    
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
        
        self.eventsTableView?.registerNib(UINib(nibName: "TREventCurrentWithCheckPointCell", bundle: nil), forCellReuseIdentifier: CURRENT_EVENT_WITH_CHECK_POINT_CELL)
        self.eventsTableView?.registerNib(UINib(nibName: "TREventCurrentNoCheckPointCell", bundle: nil), forCellReuseIdentifier: CURRENT_EVENT_NO_CHECK_POINT_CELL)
        self.eventsTableView?.registerNib(UINib(nibName: "TREventUpcomingWithCheckPointCell", bundle: nil), forCellReuseIdentifier: UPCOMING_EVENT_WITH_CHECK_POINT_CELL)
        self.eventsTableView?.registerNib(UINib(nibName: "TREventUpcomingNoCheckPointCell", bundle: nil), forCellReuseIdentifier: UPCOMING_EVENT_NO_CHECK_POINT_CELL)
        self.eventsTableView?.registerNib(UINib(nibName: "TREventActivityCardCell", bundle: nil), forCellReuseIdentifier: EVENT_ACTIVITY_CARD_CELL)

        self.eventsTableView?.tableFooterView = UIView(frame: CGRectZero)
        self.eventsTableView?.addSubview(self.refreshControl)
        
        //Adding Radius to the Current Player Avator
        self.currentPlayerAvatorIcon?.layer.cornerRadius = (self.currentPlayerAvatorIcon?.frame.width)!/2

        //Load table
        self.reloadEventTable()
        
        //Add User Avator Image
        self.updateUserAvatorImage()
        
        //Add Group Icon Image
        self.updateGroupImage()
        
        //Add Gestures to Images
        self.addLogOutEventToAvatorImageView()

        // Hide Navigation Bar
        self.hideNavigationBar()
        
        // Show No Events View if Events Table is Empty
        self.emptyTableBackGround?.hidden = self.eventsInfo.count > 0 ? true : false

        //Add Notification Permission
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.addNotificationsPermission()
    }

    func showLegalAlert () {
        
        if TRApplicationManager.sharedInstance.currentUser?.legalInfo?.privacyNeedsUpdate == true || TRApplicationManager.sharedInstance.currentUser?.legalInfo?.termsNeedsUpdate == true {
            
            self.displayAlertWithActionHandler("Update", message: "Our Terms of Service and Privacy Policy have changed. \n\n By tapping the “OK” button, you agree to the updated Terms of Service and Privacy Policy.", buttonOneTitle: "Private Policy",buttonTwoTitle: "Terms of Service",buttonThreeTitle: "OK", completionHandler: {complete in
                
                let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                switch complete! {
                case 0:
                    let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
                    legalViewController.linkToOpen = NSURL(string: "https://www.crossroadsapp.co/terms")!
                    self.presentViewController(legalViewController, animated: true, completion: {
                    })
                    
                    break
                case 1:
                    let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
                    legalViewController.linkToOpen = NSURL(string: "https://www.crossroadsapp.co/privacy")!
                    self.presentViewController(legalViewController, animated: true, completion: {
                    })
                    break
                case 2:
                    _ = TRRequestUpdateLegalRequest().updateLegalAcceptance({ (didSucceed) in
                    })
                    break
                default:
                    break
                }
            })
        }
    }
    
    //MARK:- Swipe Gestures Begins
    @IBAction func userSwipedRight (sender: UISwipeGestureRecognizer) {
        self.segmentControl?.selectedSegmentIndex = 0
        self.segmentControlSelection(self.segmentControl!)
    }

    @IBAction func userSwipedLeft (sender: UISwipeGestureRecognizer) {
        self.segmentControl?.selectedSegmentIndex = 1
        self.segmentControlSelection(self.segmentControl!)
    }
    
    //MARK:- Swipe Gestures Ends
    
    func updateUserAvatorImage () {
        
        //Avator for Current PlayerJ
        if self.currentPlayerAvatorIcon?.image == nil {
            if let imageUrl = TRUserInfo.getUserImageString() {
                let imageUrl = NSURL(string: imageUrl)
                self.currentPlayerAvatorIcon?.sd_setImageWithURL(imageUrl)
            }
        }
        
        if TRApplicationManager.sharedInstance.currentUser?.consoles.count > 1 {
            if let console = TRApplicationManager.sharedInstance.currentUser?.getDefaultConsole() {
                switch console.consoleType! {
                case ConsoleTypes.XBOXONE, ConsoleTypes.XBOX360:
                    self.currentPlayerAvatorIcon?.roundRectView(1.0, borderColor: UIColor(red: 77/255, green: 194/255, blue: 34/255, alpha: 1))
                    break
                case ConsoleTypes.PS4, ConsoleTypes.PS3:
                    self.currentPlayerAvatorIcon?.roundRectView(1.0, borderColor: UIColor(red: 1/255, green: 59/255, blue: 152/255, alpha: 1))
                    break
                default:
                    break
                }
            }
        } else {
            self.currentPlayerAvatorIcon?.roundRectView(1.0, borderColor: UIColor.whiteColor())
        }
    }
    
    func updateGroupImage () {
        
        self.playerGroupsIcon?.layer.borderColor = UIColor.whiteColor().CGColor
        self.playerGroupsIcon?.layer.borderWidth     = 1.0
        self.playerGroupsIcon?.layer.borderColor     = UIColor.whiteColor().CGColor
        self.playerGroupsIcon?.layer.masksToBounds   = true

        if let currentGroupID = TRUserInfo.getUserClanID() {
            if let hasCurrentGroup = TRApplicationManager.sharedInstance.getCurrentGroup(currentGroupID) {
                if let imageUrl = hasCurrentGroup.avatarPath {
                    let imageUrl = NSURL(string: imageUrl)
                    self.playerGroupsIcon?.sd_setImageWithURL(imageUrl)
                }
            }
        }
        
        if self.playerGroupsIcon?.image == nil {
            self.playerGroupsIcon?.image = UIImage(named: "iconGroupCrossroadsFreelance")
        }
        
        //Remove Observer running on previous clan and add it again on current clan
        TRApplicationManager.sharedInstance.fireBaseManager?.removeObservers()
        TRApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentView(self)
    }
    
    func addLogOutEventToAvatorImageView () {
        let openLeftGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TREventListViewController.avatorBtnTapped(_:)))
        self.currentPlayerAvatorIcon?.userInteractionEnabled = true
        self.currentPlayerAvatorIcon?.addGestureRecognizer(openLeftGestureRecognizer)
        
        let openRightGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TREventListViewController.showChangeGroupsVc(_:)))
        self.playerGroupsIcon?.userInteractionEnabled = true
        self.playerGroupsIcon?.addGestureRecognizer(openRightGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Reload Table
        self.reloadEventTable()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check if Legal statement has been updated
        self.showLegalAlert()
        
        //Add FireBase Observer
        TRApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentView(self)
        
        if TRApplicationManager.sharedInstance.pushNotificationViewArray.count == 0 {
            UIView.animateWithDuration(0.3) {
                self.eventTableTopConstraint?.constant = 11.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove FireBase Observer
        TRApplicationManager.sharedInstance.fireBaseManager?.removeObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override  func applicationWillEnterForeground() {
        
        //Add FireBase Observer
        if self.currentViewController?.isKindOfClass(TREventListViewController) == true {
            TRApplicationManager.sharedInstance.fireBaseManager?.removeObservers()
            TRApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentView(self)
        }

        _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: false, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
            if(didSucceed == true) {
                    self.reloadEventTable()
            } else {
                self.appManager.log.debug("Failed")
            }
        })
    }

    
    //MARK:- Table Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.eventsInfo.count > 0 || self.futureEventsInfo.count > 0 || self.activityCardsInfo.count > 0 else {
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

        if self.segmentControl?.selectedSegmentIndex == 0 {
            return self.eventsInfo.count + self.activityCardsInfo.count
        }
        
        return self.futureEventsInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: TRBaseEventTableCell?
        if segmentControl?.selectedSegmentIndex == 0 {
            
            if indexPath.section < self.eventsInfo.count {
                
                if self.eventsInfo[indexPath.section].eventActivity?.activityCheckPoint != "" && self.eventsInfo[indexPath.section].eventActivity?.activityCheckPoint != nil{
                    cell = tableView.dequeueReusableCellWithIdentifier(CURRENT_EVENT_WITH_CHECK_POINT_CELL) as! TREventCurrentWithCheckPointCell
                    self.eventsTableView?.rowHeight = EVENT_CURRENT_WITH_CHECK_POINT_CELL_HEIGHT
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier(CURRENT_EVENT_NO_CHECK_POINT_CELL) as! TREventCurrentNoCheckPointCell
                    self.eventsTableView?.rowHeight = EVENT_CURRENT_NO_CHECK_POINT_CELL_HEIGHT
                }
                
                cell?.updateCellViewWithEvent(self.eventsInfo[indexPath.section])
                cell?.joinEventButton?.buttonEventInfo = eventsInfo[indexPath.section]
                cell?.leaveEventButton.buttonEventInfo = eventsInfo[indexPath.section]
                cell?.eventTimeLabel?.hidden = true
            } else {
                
                let index = indexPath.section - self.eventsInfo.count
                let cell = tableView.dequeueReusableCellWithIdentifier(EVENT_ACTIVITY_CARD_CELL) as! TREventActivityCardCell
                cell.activityInfo = self.activityCardsInfo[index]
                cell.cellActivityAddButton?.buttonActivityInfo = self.activityCardsInfo[index]
                cell.cellActivityAddButton?.addTarget(self, action: #selector(TREventListViewController.createActivityWithActivity(_:)), forControlEvents: .TouchUpInside)
                self.eventsTableView?.rowHeight = EVENT_ACTIVITY_CELL_HEIGHT
                cell.loadCellView()
                
                return cell
            }

        } else {
            
            if self.futureEventsInfo[indexPath.section].eventActivity?.activityCheckPoint != "" && self.futureEventsInfo[indexPath.section].eventActivity?.activityCheckPoint != nil{
                cell = tableView.dequeueReusableCellWithIdentifier(UPCOMING_EVENT_WITH_CHECK_POINT_CELL) as! TREventUpcomingWithCheckPointCell
                self.eventsTableView?.rowHeight = EVENT_UPCOMING_WITH_CHECK_POINT_CELL_HEIGHT
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(UPCOMING_EVENT_NO_CHECK_POINT_CELL) as! TREventUpcomingNoCheckPointCell
                self.eventsTableView?.rowHeight = EVENT_UPCOMING_NO_CHECK_POINT_CELL_HEIGHT
            }
            
            cell?.updateCellViewWithEvent(self.futureEventsInfo[indexPath.section])
            cell?.joinEventButton?.buttonEventInfo = futureEventsInfo[indexPath.section]
            cell?.leaveEventButton.buttonEventInfo = futureEventsInfo[indexPath.section]
            cell?.eventTimeLabel?.hidden = false
        }

        cell?.joinEventButton?.addTarget(self, action: #selector(TREventListViewController.joinAnEvent(_:)), forControlEvents: .TouchUpInside)
        cell?.leaveEventButton?.addTarget(self, action: #selector(TREventListViewController.leaveAnEvent(_:)), forControlEvents: .TouchUpInside)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        self.eventsTableView?.deselectRowAtIndexPath(indexPath, animated: false)
        
        let eventInfo: TREventInfo!
        if self.segmentControl?.selectedSegmentIndex == 0 {
            if indexPath.section < self.eventsInfo.count {
                eventInfo = self.eventsInfo[indexPath.section]
                self.showEventInfoViewController(eventInfo, fromPushNoti: false)
            } else {
                
                let cell = self.eventsTableView?.cellForRowAtIndexPath(indexPath) as! TREventActivityCardCell
                
                if let _ = cell.cellActivityAddButton.buttonActivityInfo {
                        self.createActivityWithActivity(cell.cellActivityAddButton)
                }
            }
        } else {
            eventInfo = self.futureEventsInfo[indexPath.section]
            self.showEventInfoViewController(eventInfo, fromPushNoti: false)
        }
    }
    
    func showEventInfoViewController(eventInfo: TREventInfo?, fromPushNoti: Bool?) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TREventInformationViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_EVENT_INFORMATION) as! TREventInformationViewController
        vc.eventInfo = eventInfo
        
        self.presentViewController(vc, animated: true, completion: {
        })
    }
    
    func fetchEventDetailForDeepLink (eventID: String, activityName: String) {
        let eventInfo = TRApplicationManager.sharedInstance.getEventById(eventID)
        if let _ = eventInfo {
            do {
                let _ = try self.getBranchError(eventInfo!)
            } catch let errorType as Branch_Error {
                self.showBranchErrorViewWithError(errorType, eventInfo: eventInfo, activityName: activityName)
                return
            } catch {
            }
            self.showEventInfoViewController(eventInfo, fromPushNoti: false)
        } else {
            _ = TRGetEventRequest().getEventByID(eventID, viewHandlesError: true, completion: { (error, event) in
                if let _ = event {
                    do {
                        let _ = try self.getBranchError(event!)
                    } catch let errorType as Branch_Error {
                        self.showBranchErrorViewWithError(errorType, eventInfo: eventInfo, activityName: activityName)
                        return
                    } catch {
                    }
                    self.showEventInfoViewController(event, fromPushNoti: false)
                } else {
                    if let _ = error {
                        self.showBranchErrorViewWithError(Branch_Error.ACTIVITY_NOT_AVAILABLE, eventInfo: nil, activityName: activityName)
                    }
                }
            })
        }
    }
    
    func getBranchError (eventInfo: TREventInfo) throws {
        //TEST THESE CONDITIONS
        do {
            let _ = try eventInfo.isEventFull()
        } catch _ {
            throw Branch_Error.MAXIMUM_PLAYERS_REACHED
        }
        
        do {
            let _ = try eventInfo.isEventGroupPartOfUsersGroups()
        } catch _ {
            throw Branch_Error.JOIN_BUNGIE_GROUP
        }
        
        do {
            let _ = try eventInfo.isEventConsoleMatchesUserConsole()
        } catch _ {
            throw Branch_Error.NEEDS_CONSOLE
        }
    }
    
    func showBranchErrorViewWithError (errorType: Branch_Error, eventInfo: TREventInfo?, activityName: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            let errorView = NSBundle.mainBundle().loadNibNamed("TRErrorView", owner: self, options: nil)[0] as! TRErrorView
            errorView.frame = self.view.frame
            errorView.errorType = errorType
            errorView.delegate = self
            if let _ = eventInfo {
                errorView.eventInfo = eventInfo!
            }
            if let _ = activityName {
                errorView.activityName = activityName
            }
            
            self.view.addSubview(errorView)
        })
    }
    
    //Called when app is in background state
    override func didReceiveRemoteNotificationInBackGroundSession(sender: NSNotification) {
        
        // If Event Info is open, If Navigations are open, close them too
        if let topController = UIApplication.topViewController() {
            if topController.isKindOfClass(TREventInformationViewController) {
                topController.dismissViewControllerAnimated(false, completion: {
                    topController.didMoveToParentViewController(nil)
                    topController.removeFromParentViewController()
                })
            } else if (topController.navigationController != nil) {
                topController.dismissViewControllerAnimated(false, completion: {
                })
            }
        }
        
        
        if let payload = sender.userInfo!["payload"] as? NSDictionary {
            let _ = TRPushNotification().fetchEventFromPushNotification(payload, complete: { (event) in
                if let _ = event {
                    self.showEventInfoViewController(event, fromPushNoti: true)
                }
            })
        }
    }
    
    //MARK:- Event Methods
    func joinAnEvent (sender: EventButton) {
      if let eventInfo = sender.buttonEventInfo {
            _ = TRJoinEventRequest().joinEventWithUserForEvent(TRUserInfo.getUserID()!, eventInfo: eventInfo, completion: { (event) in
                if let _ = event {
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.reloadEventTable()
                    })
                }
            })
        }
    }
    
    func leaveAnEvent (sender: EventButton) {
        _  = TRLeaveEventRequest().leaveAnEvent(sender.buttonEventInfo!,completion: {(event) in
            if let _ = event {
                dispatch_async(dispatch_get_main_queue(), {
                    //self.reloadEventTable()
                })
            }
        })
    }
    
    @IBAction func createAnEvent () {

        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRCreateEventViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_CREATE_EVENT) as! TRCreateEventViewController
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.barStyle = .Black
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- Table Refresh
    func handleRefresh(refreshControl: UIRefreshControl) {

        _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: false, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
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
    
    
    
    override func reloadEventTable () {
        
        //Reload Table
        self.eventsInfo       = TRApplicationManager.sharedInstance.getCurrentEvents()
        self.futureEventsInfo = TRApplicationManager.sharedInstance.getFutureEvents()
        self.activityCardsInfo = TRApplicationManager.sharedInstance.eventsListActivity
            
        self.eventsTableView?.reloadData()
    }
    
    @IBAction func segmentControlSelection (sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.segmentOneUnderLine?.hidden = false
            self.segmentTwoUnderLine?.hidden = true
            self.emptyTableBackGround?.hidden = self.eventsInfo.count > 0 ? true : false
            
            break;
        case 1:
            self.segmentOneUnderLine?.hidden = true
            self.segmentTwoUnderLine?.hidden = false
            self.emptyTableBackGround?.hidden = self.futureEventsInfo.count > 0 ? true : false

            break;
        default:
            break;
        }
        
        //Reload Data
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.reloadEventTable()
        }
    }
    
    
    //MARK:- OTHER VIEW-CONTROLLERS
    func avatorBtnTapped(sender: AnyObject) {
        TRApplicationManager.sharedInstance.slideMenuController.openLeft()
    }
    
    @IBAction func showChangeGroupsVc (sender: AnyObject) {
        TRApplicationManager.sharedInstance.fetchBungieGroups(true, completion: { (didSucceed) in
        })
    }
    
    func createActivityWithActivity (sender: EventButton) {
        
        _ = TRgetActivityList().getActivityList({ (value) -> () in
            if (value == true) {
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : TRCreateEventConfirmationViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CREATE_EVENT_CONFIRM) as! TRCreateEventConfirmationViewController
                let navigationController = UINavigationController(rootViewController: vc)
                vc.selectedActivity = sender.buttonActivityInfo
                vc.showBackButton = false
                
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
        })
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
    
    
    //MARK:- NOTIFICATION VIEW PROTOCOL
    func notificationShowMoveTableDown (yOffSet: CGFloat) {
        
        UIView.animateWithDuration(0.3) {
            self.eventTableTopConstraint?.constant = yOffSet
            self.view.layoutIfNeeded()
        }
    }
    
    override func activeNotificationViewClosed () {
        
        if TRApplicationManager.sharedInstance.pushNotificationViewArray.count == 0 {
            UIView.animateWithDuration(0.3) {
                self.eventTableTopConstraint?.constant = 11.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func showEventDetailView (eventID: String) {
        
        let eventInfo = TRApplicationManager.sharedInstance.getEventById(eventID)
        if let _ = eventInfo {
            self.showEventInfoViewController(eventInfo, fromPushNoti: false)
        } else {
            _ = TRGetEventRequest().getEventByID(eventID, viewHandlesError: false, completion: { (error, event) in
                if let _ = event {
                    self.showEventInfoViewController(event, fromPushNoti: false)
                }
            })
        }
    }
    
    
    
    //MARK:- Error Message View Handling actions
    func addActivity () {
        self.createAnEvent()
    }
    
    func addConsole () {
        
    }
    
    func goToBungie(eventID: String?) {
        
        var url = NSURL(string: "https://www.bungie.net")
        if let _ = eventID {
            let urlString = "https://www.bungie.net/en/clan/" + eventID!
           url = NSURL(string: urlString)
        }
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    //MARK:- deinit
    deinit {
        self.eventsInfo.removeAll()
        self.futureEventsInfo.removeAll()
        self.activityCardsInfo.removeAll()
        
        //Remove Observer
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        self.appManager.log.debug("de-init")
    }
}

