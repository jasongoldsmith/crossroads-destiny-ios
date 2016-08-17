//
//  TREventInformationViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import pop
import Branch

class TREventInformationViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let EVENT_INFO_PLAYER_CELL = "eventInfoPlayersCell"
    private let HEIGHT_FOR_SECTION:CGFloat = 45
    
    var eventInfo: TREventInfo?
    
    @IBOutlet weak var eventIcon: UIImageView?
    @IBOutlet weak var eventTitle: UILabel?
    @IBOutlet weak var eventDescription: UILabel?
    @IBOutlet weak var eventLightCount: UILabel?
    @IBOutlet weak var eventInfoTable: UITableView?
    @IBOutlet weak var eventTimeLabel: UILabel?
    @IBOutlet weak var sendMessageToAllButton: UIButton?
    @IBOutlet weak var leaveEventButton: EventButton?
    @IBOutlet weak var eventActivityCheckPoint: UILabel?
    @IBOutlet weak var eventActivityCheckPointHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventActivityCheckPointTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventInfoTableTopConstraint: NSLayoutConstraint?
    
    var sendChatMessageView : TRSendChatMessageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            eventTitle?.font = UIFont(name:"HelveticaNeue", size: 17)
            eventLightCount?.font = UIFont(name:"HelveticaNeue", size: 17)
        }

        // Send Chat View
        self.sendChatMessageView = NSBundle.mainBundle().loadNibNamed("TRSendChatMessageView", owner: self, options: nil)[0] as! TRSendChatMessageView
        self.sendChatMessageView.frame = self.view.bounds
        
        guard let _ = self.eventInfo else {
            self.dismissViewController(true, dismissed: { (didDismiss) in
            })
            return
        }
        
        self.eventInfoTable?.registerNib(UINib(nibName: "TREventInfoPlayerCell", bundle: nil), forCellReuseIdentifier: EVENT_INFO_PLAYER_CELL)
        self.eventInfoTable?.tableFooterView = UIView(frame: CGRectZero)
        
        if let imageURLString = self.eventInfo?.eventActivity?.activityIconImage {
            let url = NSURL(string: imageURLString)
            self.eventIcon!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "iconGhostDefault"))
        }

        self.eventTitle?.text = self.eventInfo?.eventActivity?.activitySubType
        
        let fontStarIcon = "\u{02726}"
        if let _ = self.eventInfo?.eventActivity?.activityLight?.integerValue where self.eventInfo?.eventActivity?.activityLight?.integerValue > 0 {
            self.eventLightCount?.text = fontStarIcon + (self.eventInfo?.eventActivity?.activityLight?.stringValue)!
        } else {
            self.eventLightCount?.hidden = false
            
            let lvlString = "lvl "
            let stringFontAttribute = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15)!]
            
            let levelAttributedStr = NSAttributedString(string: lvlString, attributes: stringFontAttribute)
            let activityLevelAttributedStr = NSAttributedString(string: (self.eventInfo?.eventActivity?.activityLevel)!, attributes: nil)
            
            let finalString:NSMutableAttributedString = levelAttributedStr.mutableCopy() as! NSMutableAttributedString
            finalString.appendAttributedString(activityLevelAttributedStr)
            
            self.eventLightCount?.attributedText = finalString
        }
        
        if let eventCheckPoint = self.eventInfo?.eventActivity?.activityCheckPoint where eventCheckPoint != "" {
            self.eventActivityCheckPoint?.text = eventCheckPoint
        } else {
            self.eventActivityCheckPointHeightConstraint.constant = 0
            self.eventActivityCheckPointTopConstraint.constant = -1
            self.updateViewConstraints()
        }
        
        // Set  Event Player Names
        self.updateEventStatusAndPlayerNameString()
        
        // Set date string
        if (eventInfo?.isFutureEvent == true) {
            //Event time label
            if let hasLaunchDate = self.eventInfo?.eventLaunchDate {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let eventDate = formatter.dateFromString(hasLaunchDate)
                self.eventTimeLabel?.text = eventDate!.toString(format: .Custom(trDateFormat()))
            }
        } else {
            self.eventTimeLabel?.hidden = true
        }
     
        //Leave Event and Send Message To All button update
        self.leaveEventButton?.buttonEventInfo = self.eventInfo
        self.updateBottomButtons()
    }
    
    func updateBottomButtons () {
        //Hide Send All message if user is not part of the event
        let isCurrentUserCreatorOfEvent = TRApplicationManager.sharedInstance.isCurrentPlayerCreatorOfTheEvent(self.eventInfo!)
        let isCurrentUserInTheEvent = TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(self.eventInfo!)
        
        if (isCurrentUserCreatorOfEvent == true) {
            if self.eventInfo?.eventPlayersArray.count > 1 {
                self.sendMessageToAllButton?.hidden = false
                self.leaveEventButton?.hidden = true
            } else {
                // Only 1 user and he is the creator, he cant send message to himself
                self.sendMessageToAllButton?.hidden = true
                self.leaveEventButton?.hidden = false
            }
        } else {
            self.sendMessageToAllButton?.hidden = true
            self.leaveEventButton?.removeTarget(self, action: #selector(leaveEvent(_:)), forControlEvents: .TouchUpInside)
            self.leaveEventButton?.removeTarget(self, action: #selector(joinAnEvent(_:)), forControlEvents: .TouchUpInside)
            
            if (isCurrentUserInTheEvent) {
                self.leaveEventButton?.hidden = false
                self.leaveEventButton?.setTitle("LEAVE ACTIVITY", forState: .Normal)
                self.leaveEventButton?.backgroundColor = UIColor(red: 255/255, green: 175/255, blue: 0/255, alpha: 1)
                self.leaveEventButton?.addTarget(self, action: #selector(leaveEvent(_:)), forControlEvents: .TouchUpInside)
            } else {
                if self.eventInfo?.eventStatus == EVENT_STATUS.FULL.rawValue {
                    self.leaveEventButton?.hidden = true
                    return
                }

                self.leaveEventButton?.hidden = false
                self.leaveEventButton?.setTitle("JOIN ACTIVITY", forState: .Normal)
                self.leaveEventButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
                self.leaveEventButton?.addTarget(self, action: #selector(joinAnEvent(_:)), forControlEvents: .TouchUpInside)
            }
        }
    }
    
    func updateEventStatusAndPlayerNameString () {
        if (self.eventInfo?.eventPlayersArray.count < self.eventInfo?.eventActivity?.activityMaxPlayers?.integerValue) {
            let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)]
            let extraPlayersRequiredCount = ((self.eventInfo?.eventActivity?.activityMaxPlayers?.integerValue)! - (self.eventInfo?.eventPlayersArray.count)!)
            let extraPlayersRequiredCountString = String(extraPlayersRequiredCount)
            let extraPlayersRequiredCountStringNew = " LF" + "\(extraPlayersRequiredCountString)M"
            
            // Attributed Strings
            let extraPlayersRequiredCountStringNewAttributed = NSAttributedString(string: extraPlayersRequiredCountStringNew, attributes: stringColorAttribute)
            if let _ = self.eventInfo?.eventCreator?.playerPsnID {
                let finalString = NSMutableAttributedString(string: (self.eventInfo?.eventCreator?.playerPsnID!)!)
                finalString.appendAttributedString(extraPlayersRequiredCountStringNewAttributed)
                self.eventDescription?.attributedText = finalString
            }
        } else {
            let playersNameString = (self.eventInfo?.eventCreator?.playerPsnID!)!
            self.eventDescription?.text = playersNameString
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        TRApplicationManager.sharedInstance.pushNotiController?.showAllNotificationsWithEventID(eventInfo!.eventID!, parentView: self)

//        TRApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentViewForDetailView(self,withEvent: self.eventInfo!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove FireBase Observer
        TRApplicationManager.sharedInstance.fireBaseManager?.removeObservers()
    }
    
    @IBAction func backButtonPressed (sender: AnyObject) {

        self.dismissViewController(true) { (didDismiss) in
            // Show event detail view controller
            TRApplicationManager.sharedInstance.pushNotiController?.deleteAllNotificationsWithEventID(self.eventInfo!.eventID!)
        }
    }
    
    //MARK:- UITable Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let _ = self.eventInfo {
            return (self.eventInfo?.eventActivity?.activityMaxPlayers?.integerValue)!
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerBottomSeperator = UIView()
        let viewLabel = UILabel()
        
        viewLabel.frame = CGRectMake(20, 0, self.eventInfoTable!.frame.size.width, HEIGHT_FOR_SECTION)
        viewLabel.textColor = UIColor.whiteColor()
        viewLabel.font = UIFont(name:"HelveticaNeue", size: 12)
        headerView.addSubview(viewLabel)

        headerBottomSeperator.frame = CGRectMake(20, HEIGHT_FOR_SECTION - 8, self.eventInfoTable!.frame.size.width - 40, 1.0)
        headerBottomSeperator.backgroundColor = UIColor.grayColor()
        headerView.addSubview(headerBottomSeperator)
        
        switch section {
        case 0:
            viewLabel.text = "Currently Going"
            break
        default:
            viewLabel.text = "N/A"
            break
        }
        
        self.eventInfoTable?.tableHeaderView = headerView
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_FOR_SECTION
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(EVENT_INFO_PLAYER_CELL) as! TREventInfoPlayerCell
        
        if indexPath.row < self.eventInfo?.eventPlayersArray.count {
            cell.updateCellViewWithEvent((self.eventInfo?.eventPlayersArray[indexPath.row])!, eventInfo: self.eventInfo!)
            cell.chatButton?.tag = indexPath.row
            cell.chatButton?.addTarget(self, action: #selector(TREventInformationViewController.sendChatMessage(_:)), forControlEvents: .TouchUpInside)
        } else {
            cell.playerAvatorImageView?.image = UIImage(named: "iconProfileBlank")
            cell.playerNameLable?.text = "searching..."
            cell.chatButton?.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.eventInfoTable?.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    override func reloadEventTable () {

        guard let _ = self.eventInfo else {
            self.dismissViewController(true, dismissed: { (didDismiss) in
                
            })
            
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) { 
            self.eventInfoTable?.reloadData()
            self.updateBottomButtons()
            self.updateEventStatusAndPlayerNameString()
        }
    }
    
    
    //MARK: Network Request Methods
    
    func sendChatMessage(sender: EventButton) {
        
        guard let player = sender.buttonPlayerInfo else {
            
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("No Player Object Found")
            return
        }
        
        self.sendChatMessageView.sendToLabel.text = "To: " + (self.eventInfo?.eventPlayersArray[sender.tag].playerPsnID!)!
        self.sendChatMessageView.userId = player.playerID
        self.sendChatMessageView.eventId = self.eventInfo?.eventID
        self.sendChatMessageView.sendToAll = false
        self.sendChatMessageView.alpha = 0.0
        self.view.addSubview(self.sendChatMessageView)
        
        let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        popAnimation.toValue = 1.0
        popAnimation.duration = 0.3
        self.sendChatMessageView.pop_addAnimation(popAnimation, forKey: "alphasIn")
    }
    
    
    @IBAction func leaveEvent(eventInfoButton: EventButton) {
        
        guard let buttonHasEvent = eventInfoButton.buttonEventInfo else {
            return
        }
        
        _ = TRLeaveEventRequest().leaveAnEvent(buttonHasEvent, completion: { (event) in
            if let _ = event {
                self.eventInfo = event
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let _ = self.eventInfo {
                        self.reloadEventTable()
                    }
                }
            } else {
                self.dismissViewController(true, dismissed: { (didDismiss) in
                    
                })
            }
        })
    }
    
    func joinAnEvent (eventInfoButton: EventButton) {
        
        guard let buttonHasEvent = eventInfoButton.buttonEventInfo else {
            return
        }
        
        
        _ = TRJoinEventRequest().joinEventWithUserForEvent(TRUserInfo.getUserID()!, eventInfo: buttonHasEvent, completion: { (event) in
            if let _ = event {
                self.eventInfo = event
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.reloadEventTable()
                }
            }
        })
     }
    
    //MARK:- Send Message To All
    @IBAction func sendMessageToAll (sender: UIButton) {
        
        self.sendChatMessageView.sendToLabel.text = "To: All Players"
        self.sendChatMessageView.sendToAll = true
        self.sendChatMessageView.eventId = self.eventInfo?.eventID
        self.view.addSubview(self.sendChatMessageView)
        
        let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        popAnimation.toValue = 1.0
        popAnimation.duration = 0.3
        self.sendChatMessageView.alpha = 0.0
        self.sendChatMessageView.pop_addAnimation(popAnimation, forKey: "alphasIn")
    }

    
    //MARK:- Share Sheet
    @IBAction func openShareSheet (sender: UIButton) {
        
        TRApplicationManager.sharedInstance.branchManager?.createLinkWithBranch(self.eventInfo!, deepLinkType: BRANCH_DEEP_LINKING_END_POINT.EVENT_DETAIL.rawValue, callback: {(url, error) in
            if (error == nil) {
                print(url)
                // Group to Share
                let groupToShare = [url!] as [AnyObject]
                
                let activityViewController = UIActivityViewController(activityItems: groupToShare , applicationActivities: nil)
                self.presentViewController(activityViewController, animated: true, completion: {})
            } else {
                print(String(format: "Branch TestBed: %@", error))
            }
        })
    }
    
    //MARK:- NOTIFICATION VIEW PROTOCOL
    func notificationShowMoveTableDown (yOffSet: CGFloat) {
        UIView.animateWithDuration(0.3) {
            self.eventInfoTableTopConstraint?.constant = yOffSet
            self.view.layoutIfNeeded()
        }
    }
    
    override func activeNotificationViewClosed () {
        
        for obj in TRApplicationManager.sharedInstance.pushNotificationViewArray {
            if obj.pushInfo?.eventID == self.eventInfo?.eventID && obj.pushInfo?.isMessageNotification ==   true {
                return
            }
        }
        
        UIView.animateWithDuration(0.3) {
            self.eventInfoTableTopConstraint?.constant = 11.0
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

