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


class TREventInformationViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let EVENT_INFO_PLAYER_CELL = "eventInfoPlayersCell"
    private let HEIGHT_FOR_SECTION:CGFloat = 30
    
    var eventInfo: TREventInfo?
    
    @IBOutlet weak var eventIcon: UIImageView?
    @IBOutlet weak var eventTitle: UILabel?
    @IBOutlet weak var eventDescription: UILabel?
    @IBOutlet weak var eventLightCount: UILabel?
    @IBOutlet weak var eventInfoTable: UITableView?
    @IBOutlet weak var eventTimeLabel: UILabel?
    @IBOutlet weak var sendMessageToAllButton: UIButton?
    @IBOutlet weak var leaveEventButton: EventButton?
    
    var sendChatMessageView : TRSendChatMessageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.eventIcon!.sd_setImageWithURL(url)
        }

        self.eventTitle?.text = self.eventInfo?.eventActivity?.activitySubType
        
        if let _ = self.eventInfo?.eventActivity?.activityLight?.integerValue where self.eventInfo?.eventActivity?.activityLight?.integerValue > 0 {
            self.eventLightCount?.text = "+" + (self.eventInfo?.eventActivity?.activityLight?.stringValue)!
        } else {
            self.eventLightCount?.hidden = true
        }
        
        
        // Set  Event Player Names
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
        
        
        if (eventInfo?.isFutureEvent == true) {
            //Event time label
            if let hasLaunchDate = self.eventInfo?.eventLaunchDate {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let eventDate = formatter.dateFromString(hasLaunchDate)
                self.eventTimeLabel?.text = eventDate!.toString()
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
            }
        } else {
            self.sendMessageToAllButton?.hidden = true
            self.leaveEventButton?.removeTarget(self, action: #selector(leaveEvent(_:)), forControlEvents: .TouchUpInside)
            self.leaveEventButton?.removeTarget(self, action: #selector(joinAnEvent(_:)), forControlEvents: .TouchUpInside)
            
            if (isCurrentUserInTheEvent) {
                self.leaveEventButton?.hidden = false
                self.leaveEventButton?.setTitle("LEAVE EVENT", forState: .Normal)
                self.leaveEventButton?.backgroundColor = UIColor(red: 255/255, green: 175/255, blue: 0/255, alpha: 1)
                self.leaveEventButton?.addTarget(self, action: #selector(leaveEvent(_:)), forControlEvents: .TouchUpInside)
            } else {
                self.leaveEventButton?.hidden = false
                self.leaveEventButton?.setTitle("JOIN EVENT", forState: .Normal)
                self.leaveEventButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
                self.leaveEventButton?.addTarget(self, action: #selector(joinAnEvent(_:)), forControlEvents: .TouchUpInside)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func backButtonPressed (sender: AnyObject) {
        self.dismissViewController(true) { (didDismiss) in
        }
    }
    
    //MARK:- UITable Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let _ = self.eventInfo {
            return (self.eventInfo?.eventActivity?.activityMaxPlayers?.integerValue)!
        }
        
        return 0
//        if let _ = self.eventInfo {
//            let isCurrentPlayerInEvent = TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(self.eventInfo!)
//            let maxPlayersReached = self.eventInfo?.eventPlayersArray.count == self.eventInfo?.eventActivity?.activityMaxPlayers
//            let isEventFull = (eventInfo?.eventStatus == EVENT_STATUS.FULL.rawValue)
//            
//            if isCurrentPlayerInEvent || maxPlayersReached || isEventFull {
//                return (self.eventInfo?.eventPlayersArray.count)!
//            }
//            
//            return (self.eventInfo?.eventPlayersArray.count)! + 1
//        }
//        
//        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerBottomSeperator = UIView()
        let viewLabel = UILabel()
        
        viewLabel.frame = CGRectMake(20, 0, self.eventInfoTable!.frame.size.width, HEIGHT_FOR_SECTION)
        viewLabel.textColor = UIColor.whiteColor()
        viewLabel.font = UIFont(name:"HelveticaNeue", size: 12)
        headerView.addSubview(viewLabel)

        headerBottomSeperator.frame = CGRectMake(20, HEIGHT_FOR_SECTION, self.eventInfoTable!.frame.size.width - 40, 1.0)
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
            cell.playerNameLable?.text = "Searching ..."
            cell.chatButton?.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.eventInfoTable?.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func reloadEventTable () {
        self.eventInfo = TRApplicationManager.sharedInstance.getEventById((self.eventInfo?.eventID)!)
        self.eventInfoTable?.reloadData()
        self.updateBottomButtons()
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
        
        _ = TRLeaveEventRequest().leaveAnEvent(buttonHasEvent, completion: { (didSucceed) in
            if (didSucceed == true) {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if let _ = TRApplicationManager.sharedInstance.getEventById((self.eventInfo?.eventID)!) {
                        self.reloadEventTable()
                    } else {
                        self.dismissViewController(true, dismissed: { (didDismiss) in
                            
                        })
                    }
                }
            } else {
            }
        })
    }
    
    func joinAnEvent (eventInfoButton: EventButton) {
        
        guard let buttonHasEvent = eventInfoButton.buttonEventInfo else {
            return
        }
        
        _ = TRJoinEventRequest().joinEventWithUserForEvent(TRUserInfo.getUserID()!, eventInfo: buttonHasEvent, completion: { (value) -> () in
            if (value == true) {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.reloadEventTable()
                }
            } else {
                print("Failed")
            }
        })
    }
    
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

}

