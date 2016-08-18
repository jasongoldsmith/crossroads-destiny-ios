//
//  TREventDetailViewController.swift
//  Traveler
//
//  Created by Ashutosh on 8/16/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TREventDetailViewController: TRBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    
    private let EVENT_DESCRIPTION_CELL = "eventDescriptionCell"
    private let EVENT_COMMENT_CELL = "eventCommentCell"
    
    //Cell Height
    private let event_description_row_height: CGFloat = 54
    
    //Segment Control
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var segmentOneUnderLine: UIImageView?
    @IBOutlet weak var segmentTwoUnderLine: UIImageView?
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTag: TRInsertLabel!
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var eventCheckPoint_Time: UILabel!
    @IBOutlet weak var eventBackGround: UIImageView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    //Chat View
    @IBOutlet weak var chatTextBoxView: UIView!
    @IBOutlet weak var chatTextView: UITextView!
    
    
    //LayOut Constraints
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventCheckPointTopConstraint: NSLayoutConstraint!
    
    
    //Current Event
    var eventInfo: TREventInfo?
    var hasTag: Bool = false
    var hasCheckPoint: Bool = false
    var isFutureEvent: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = self.eventInfo else {
            return
        }
        
        //TextView Delegate
        self.chatTextView?.layer.cornerRadius = 4.0
        self.chatTextView?.text = "Type your comment here"
        self.chatTextView?.textColor = UIColor.lightGrayColor()
        
        //Key Board Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSignInViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSignInViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)

        
        self.segmentControl?.removeBorders()
        
        let boldFont = UIFont(name: "Helvetica-Bold", size: 14.0)
        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : boldFont!,
            ]
        
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, forState: .Normal)
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, forState: .Selected)
        
        if let hasImage = self.eventInfo?.eventActivity?.activityIconImage {
            let imageURL = NSURL(string: hasImage)
            self.eventIcon.sd_setImageWithURL(imageURL)
        }
        
        if let hasTag = self.eventInfo?.eventActivity?.activityTag where hasTag != "" {
            self.eventTag.text = hasTag
            self.eventTag.layer.cornerRadius = 2
            self.eventTag.clipsToBounds = true
            self.hasTag = true
        } else {
            self.eventTag.hidden = true
        }
        
        self.eventName.text = self.eventInfo?.eventActivity?.activitySubType
        
        // Table View
        self.eventTable?.registerNib(UINib(nibName: "TREventDescriptionCell", bundle: nil), forCellReuseIdentifier: EVENT_DESCRIPTION_CELL)
        self.eventTable?.registerNib(UINib(nibName: "TREventCommentCell", bundle: nil), forCellReuseIdentifier: EVENT_COMMENT_CELL)
        self.eventTable?.estimatedRowHeight = event_description_row_height
        self.eventTable?.rowHeight = UITableViewAutomaticDimension
        self.eventTable?.setNeedsLayout()
        self.eventTable?.layoutIfNeeded()
        
        if let hasCheckPoint = self.eventInfo?.eventActivity?.activityCheckPoint where hasCheckPoint != "" {
            self.hasCheckPoint = true
            let checkPoint = hasCheckPoint
            let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)]
            
            let checkAttributedStr = NSAttributedString(string: checkPoint + "  ", attributes: stringColorAttribute)

            let finalString:NSMutableAttributedString = checkAttributedStr.mutableCopy() as! NSMutableAttributedString
            
            if self.eventInfo?.isFutureEvent == true {
                self.isFutureEvent = true
                
                if let hasLaunchDate = self.eventInfo?.eventLaunchDate {
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let eventDate = formatter.dateFromString(hasLaunchDate)
                    let dateString = eventDate!.toString(format: .Custom(trDateFormat()))
                    
                    let timeAttributedStr = NSAttributedString(string: dateString, attributes: nil)
                    finalString.appendAttributedString(timeAttributedStr)
                }
            }
            
            self.eventCheckPoint_Time?.attributedText = finalString
        } else if (self.eventInfo?.isFutureEvent == true){
            self.isFutureEvent = true
            
            if let hasLaunchDate = self.eventInfo?.eventLaunchDate {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let eventDate = formatter.dateFromString(hasLaunchDate)
                let dateString = eventDate!.toString(format: .Custom(trDateFormat()))
                
                let timeAttributedStr = NSAttributedString(string: dateString, attributes: nil)
                //finalString.appendAttributedString(timeAttributedStr)
                self.eventCheckPoint_Time?.attributedText = timeAttributedStr
            }
        } else {
            self.eventCheckPointTopConstraint.constant = -13
            self.eventCheckPoint_Time.hidden = true
        }
        
        self.reloadButton()
        
        if let hasImage = self.eventInfo?.eventActivity!.activityImage where hasImage != "" {
            let imageURL = NSURL(string: hasImage)
            self.eventBackGround.sd_setImageWithURL(imageURL)
        }
        
        //Update Comment count on segment tab
//        let commentString: String = "COMMENTS"
//        let commentFontAttribute = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 14)!]
//        let commentAttributedStr = NSAttributedString(string: commentString, attributes: commentFontAttribute)
//        let countAttributedStr = NSAttributedString(string:  "\(self.eventInfo?.eventComments.count)", attributes: nil)
//        
//        //countAttributedStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1) , range: NSMakeRange(0, countAttributedStr.length))
//        
//        let finalString: NSMutableAttributedString = commentAttributedStr.mutableCopy() as! NSMutableAttributedString
//        finalString.appendAttributedString(countAttributedStr)
        
        
        //Update Comment Count
        if let hasComments = self.eventInfo?.eventComments.count {
            let commentString = "COMMENTS (\(hasComments))"
            self.segmentControl?.setTitle(commentString, forSegmentAtIndex: 1)
        }
        
        //Title Placements
        if (self.hasCheckPoint == true && self.hasTag == true) {
            
        } else if (self.hasCheckPoint == true || self.hasTag == true || self.isFutureEvent == true) {
            self.titleHeightConstraint.constant = 170
            self.iconHeightConstraint.constant = 170
        } else {
            self.titleHeightConstraint.constant = 185
            self.iconHeightConstraint.constant = 180
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        TRApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentViewForDetailView(self, withEvent: self.eventInfo!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove FireBase Observer
        TRApplicationManager.sharedInstance.fireBaseManager?.removeObservers()
    }
    
    func reloadButton () {
        
        self.joinButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        self.chatTextBoxView?.hidden = true
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            let isCurrentUserInTheEvent = TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(self.eventInfo!)
            if isCurrentUserInTheEvent == true {
                self.joinButton?.backgroundColor = UIColor(red: 230/255, green: 178/255, blue: 0/255, alpha: 1)
                self.joinButton?.addTarget(self, action: #selector(leaveEvent(_:)), forControlEvents: .TouchUpInside)
                self.joinButton?.setTitle("LEAVE", forState: .Normal)
            } else {
                self.joinButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
                self.joinButton?.addTarget(self, action: #selector(joinAnEvent(_:)), forControlEvents: .TouchUpInside)
                self.joinButton?.setTitle("JOIN", forState: .Normal)
            }
        } else {
            self.tableViewScrollToBottom(true)
            let isCurrentUserInTheEvent = TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(self.eventInfo!)
            if isCurrentUserInTheEvent == true {
                self.chatTextBoxView?.hidden = false
                self.sendMessageButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                self.sendMessageButton.addTarget(self, action: #selector(sendMessage(_:)), forControlEvents: .TouchUpInside)
            } else {
                self.joinButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
                self.joinButton?.addTarget(self, action: #selector(joinAnEvent(_:)), forControlEvents: .TouchUpInside)
                self.joinButton.setTitle("JOIN", forState: .Normal)
            }
        }
    }
    
    //MARK:- IB_ACTIONS
    @IBAction func dismissButton (sender: UIButton) {
        
        if self.chatTextView?.isFirstResponder() == true {
            self.chatTextView.resignFirstResponder()
        }
        
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }
    
    @IBAction func shareButton (sender: UIButton) {
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
        self.reloadEventTable()
        self.reloadButton()
    }
    
    
    //MARK:- Table View Delegates
    func tableViewScrollToBottom(animated: Bool) {
        
        if self.segmentControl?.selectedSegmentIndex == 1 {
            if self.eventInfo?.eventComments.count < 1 {
                return
            }
        }
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.eventTable?.numberOfSections
            let numberOfRows = self.eventTable?.numberOfRowsInSection(numberOfSections!-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows!-1, inSection: (numberOfSections!-1))
                self.eventTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            if section == 0 {
                let headerView = UILabel()
                headerView.text = self.eventInfo?.clanName
                headerView.textAlignment = .Center
                headerView.textColor = UIColor.whiteColor()
                headerView.font = UIFont(name:"HelveticaNeue", size: 12)
                headerView.backgroundColor = UIColor(red: 32/255, green: 50/255, blue: 54/255, alpha: 1)
                
                return headerView
            }
        }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            if section == 0 {
                return 44.0
            }
        }
        
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            if self.eventInfo?.eventPlayersArray.count < self.eventInfo?.eventMaxPlayers?.integerValue {
                return (self.eventInfo?.eventPlayersArray.count)! + 1
            }
            
            return (self.eventInfo?.eventPlayersArray.count)!
        } else {
            return (self.eventInfo?.eventComments.count)!
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: TREventDescriptionCell?
        
        if segmentControl?.selectedSegmentIndex == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(EVENT_DESCRIPTION_CELL) as? TREventDescriptionCell
            self.eventTable?.rowHeight = event_description_row_height
            
            if indexPath.section < self.eventInfo?.eventPlayersArray.count {
                cell?.playerUserName.text = self.eventInfo?.eventPlayersArray[indexPath.section].playerPsnID
                
                if let hasImage = self.eventInfo?.eventPlayersArray[indexPath.section].playerImageUrl {
                    let imageURL = NSURL(string: hasImage)
                    cell?.playerIcon.sd_setImageWithURL(imageURL)
                    cell?.playerIcon.roundRectView (1, borderColor: UIColor.grayColor())
                    
                    return cell!
                }
            } else {
                cell?.playerIcon?.image = UIImage(named: "iconProfileBlank")
                cell?.playerUserName?.text = "searching..."
                
                return cell!
            }
        } else {
            let commentCell: TREventCommentCell = (tableView.dequeueReusableCellWithIdentifier(EVENT_COMMENT_CELL) as? TREventCommentCell)!
            commentCell.playerUserName.text = self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userName!
            commentCell.playerComment.text = self.eventInfo?.eventComments[indexPath.section].commentText!
            self.eventTable?.estimatedRowHeight = event_description_row_height
            self.eventTable?.rowHeight = UITableViewAutomaticDimension

            
            if let hasTime = self.eventInfo?.eventComments[indexPath.section].commentCreated {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                let updateDate = formatter.dateFromString(hasTime)
                updateDate!.relative()
                
                commentCell.messageTimeLabel?.text = updateDate!.relative()
            }
            
            if let hasImage = self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userImageURL! {
                let imageURL = NSURL(string: hasImage)
                commentCell.playerIcon.sd_setImageWithURL(imageURL)
                commentCell.playerIcon.roundRectView (1, borderColor: UIColor.grayColor())
            }

            return commentCell
        }
    
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if segmentControl?.selectedSegmentIndex == 1 {
            self.chatTextView.resignFirstResponder()
        }
    }

    override func reloadEventTable() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let _ = self.eventInfo {

                //Update Comment Count
                if let hasComments = self.eventInfo?.eventComments.count {
                    let commentString = "COMMENTS (\(hasComments))"
                    self.segmentControl?.setTitle(commentString, forSegmentAtIndex: 1)
                }
                
                //Reload Data
                self.eventTable?.reloadData()
            }
        }
    }
    
    //MARK:- Network requests
    func leaveEvent (sender: UIButton) {
        
        guard let _ = self.eventInfo else {
            return
        }
        
        _ = TRLeaveEventRequest().leaveAnEvent(self.eventInfo!, completion: { (event) in
            if let _ = event {
                self.eventInfo = event
                self.reloadEventTable()
                self.reloadButton()
            } else {
                self.dismissViewController(true, dismissed: { (didDismiss) in
                    
                })
            }
        })
    }
    
    func joinAnEvent (sender: UIButton) {
        guard let _ = self.eventInfo else {
            return
        }
        
        _ = TRJoinEventRequest().joinEventWithUserForEvent(TRUserInfo.getUserID()!, eventInfo: self.eventInfo!, completion: { (event) in
            if let _ = event {
                self.eventInfo = event
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.reloadEventTable()
                    self.reloadButton()
                }
            }
        })
    }
    
    func sendMessage (sender: UIButton) {
        
        if let textMessage = self.chatTextView.text where textMessage != "type your comment here" {
            _ = TRSendPushMessage().sendEventMessage((self.eventInfo?.eventID!)!, messageString: textMessage, completion: { (didSucceed) in
                if (didSucceed != nil)  {
                    //Clear Text 
                    self.chatTextView.text = nil
                } else {
                }
            })
        }
    }
    
    //MARK:- Text View Methods
    func textViewDidChange(textView: UITextView) {
        
        let rows = (textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom) / textView.font!.lineHeight
        let myRowsInInt: Int = Int(rows)
        
        if (myRowsInInt > 1 && myRowsInInt <= 4) {
            let contentSizeHeight = textView.contentSize.height
            self.textViewHeightConstraint.constant = contentSizeHeight
            self.view.updateConstraints()
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(textField: UITextView) {
        self.chatTextView?.becomeFirstResponder()
        
        if self.chatTextView?.textColor == UIColor.lightGrayColor() {
            self.chatTextView?.text = nil
            self.chatTextView?.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type your comment here"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
        
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        if self.view.frame.origin.y == self.view.frame.origin.y - keyboardSize.height {
            self.view.frame.origin.y += keyboardSize.height
        }
        else {
            self.view.frame.origin.y = 0
        }
    }
    
    deinit {
        
    }
}