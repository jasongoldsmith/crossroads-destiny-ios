//
//  TREventInformationViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TREventInformationViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let EVENT_INFO_PLAYER_CELL = "eventInfoPlayersCell"
    private let HEIGHT_FOR_SECTION:CGFloat = 30
    
    var eventInfo: TREventInfo?
    
    @IBOutlet weak var eventIcon: UIImageView?
    @IBOutlet weak var eventTitle: UILabel?
    @IBOutlet weak var eventDescription: UILabel?
    @IBOutlet weak var eventLightCount: UILabel?
    @IBOutlet weak var eventInfoTable: UITableView?
    @IBOutlet var eventTimeLabel: UILabel?
    
    var sendChatMessageView : TRSendChatMessageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sendChatMessageView = NSBundle.mainBundle().loadNibNamed("TRSendChatMessageView", owner: self, options: nil)[0] as! TRSendChatMessageView
        let xAxiDistance:CGFloat  = 0
        let yAxisDistance:CGFloat = 300
        
        if let topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            self.sendChatMessageView.frame = CGRectMake(xAxiDistance, yAxisDistance, topController.view.bounds.width, self.sendChatMessageView.frame.height)
            self.sendChatMessageView.removeFromSuperview()
        }
                
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
        self.eventLightCount?.text = "+" + (self.eventInfo?.eventActivity?.activityLight?.stringValue)!
        
        // Set  Event Player Names
        if (self.eventInfo?.eventPlayersArray.count < self.eventInfo?.eventActivity?.activityMaxPlayers?.integerValue) {
            let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)]
            let extraPlayersRequiredCount = ((self.eventInfo?.eventActivity?.activityMaxPlayers?.integerValue)! - (self.eventInfo?.eventPlayersArray.count)!)
            let extraPlayersRequiredCountString = String(extraPlayersRequiredCount)
            let extraPlayersRequiredCountStringNew = " LF" + "\(extraPlayersRequiredCountString)M"
            
            // Attributed Strings
            let extraPlayersRequiredCountStringNewAttributed = NSAttributedString(string: extraPlayersRequiredCountStringNew, attributes: stringColorAttribute)
            if let _ = self.eventInfo?.eventCreator?.playerPsnID {
                let finalString = NSMutableAttributedString(string: "Created by " + (self.eventInfo?.eventCreator?.playerPsnID!)!)
                finalString.appendAttributedString(extraPlayersRequiredCountStringNewAttributed)
                self.eventDescription?.attributedText = finalString
            }
        } else {
            let playersNameString = "Created by " + (self.eventInfo?.eventCreator?.playerPsnID!)!
            self.eventDescription?.text = playersNameString
        }
        
        
        //Event time label
        if let hasLaunchDate = self.eventInfo?.eventLaunchDate {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let eventDate = formatter.dateFromString(hasLaunchDate)
            self.eventTimeLabel?.text = eventDate!.toString()
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
        
        let isCurrentPlayerInEvent = TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(self.eventInfo!)
        let maxPlayersReached = self.eventInfo?.eventPlayersArray.count == self.eventInfo?.eventActivity?.activityMaxPlayers
        let isEventFull = (eventInfo?.eventStatus == EVENT_STATUS.FULL.rawValue)
        
        if isCurrentPlayerInEvent || maxPlayersReached || isEventFull {
            return (self.eventInfo?.eventPlayersArray.count)!
        }

        return (self.eventInfo?.eventPlayersArray.count)! + 1
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
            if (TRApplicationManager.sharedInstance.isCurrentPlayerCreatorOfTheEvent(self.eventInfo!)) {
                cell.chatButton?.hidden = false
            }
            cell.chatButton?.tag = indexPath.row
            cell.chatButton?.addTarget(self, action: #selector(TREventInformationViewController.sendChatMessage(_:)), forControlEvents: .TouchUpInside)
            cell.leaveEventButton?.addTarget(self, action: #selector(TREventInformationViewController.leaveEvent(_:)), forControlEvents: .TouchUpInside)
        } else {
            cell.chatButton?.hidden = true
            cell.leaveEventButton?.hidden = true
            cell.playerAvatorImageView?.image = UIImage(named: "imgJoin")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.eventInfoTable?.deselectRowAtIndexPath(indexPath, animated: false)
        
        if indexPath.row == self.eventInfo?.eventPlayersArray.count {
            self.joinAnEvent(self.eventInfo!)
        }
    }
    
    func reloadEventTable () {
        self.eventInfo = TRApplicationManager.sharedInstance.getEventById((self.eventInfo?.eventID)!)
        self.eventInfoTable?.reloadData()
    }
    
    
    func sendChatMessage(sender: EventButton) {
        
        guard let player = sender.buttonPlayerInfo else {
            
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("No Player Object Found")
            return
        }
        self.sendChatMessageView.sendToLabel.text = "To: " + (self.eventInfo?.eventPlayersArray[sender.tag].playerPsnID!)!
        self.sendChatMessageView.userId = player.playerID
        self.sendChatMessageView.eventId = self.eventInfo?.eventID
        self.view.addSubview(self.sendChatMessageView)
    }
    
    
    func leaveEvent(sender: EventButton) {
        guard let event = sender.buttonEventInfo else {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("No Event Object Found")
            return

        }
        
        _ = TRLeaveEventRequest().leaveAnEvent(event, completion: { (didSucceed) in
            if (didSucceed == true) {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.reloadEventTable()
                }
            } else {
            }
        })
    }
    
    func joinAnEvent (eventInfo: TREventInfo) {
        
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

