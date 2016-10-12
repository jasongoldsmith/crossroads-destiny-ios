//
//  TREventDetailViewController.swift
//  Traveler
//
//  Created by Ashutosh on 8/16/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import pop

class TREventDetailViewController: TRBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CustomErrorDelegate {
    
    
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
    
    //Event Full View
    @IBOutlet weak var fullViewsheaderLabel: UILabel!
    @IBOutlet weak var fullViewsDescriptionLabel: UILabel!
    
    //LayOut Constraints
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventCheckPointTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftSectionUnderLineRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightSectionUnderLineLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventInfoTableTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var eventFullViewBottomConstraint: NSLayoutConstraint?
    
    
    //Current Event
    var eventInfo: TREventInfo?
    var hasTag: Bool = false
    var hasCheckPoint: Bool = false
    var isFutureEvent: Bool = false
    var chatViewOriginalContentSize: CGSize?
    var chatViewOriginalFrame: CGRect?
    var selectedComment: TRCommentInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = self.eventInfo else {
            return
        }
        
        //TextView Delegate
        self.chatTextView?.layer.cornerRadius = 4.0
        self.chatTextView?.text = "Type your comment here"
        self.chatTextView?.textColor = UIColor.lightGrayColor()
        self.chatTextView.layer.cornerRadius = 3.0
        
        //Key Board Observer
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSignInViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSignInViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)

        
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
        
        //Activity Name Label
        if var eventSubType = self.eventInfo?.eventActivity?.activitySubType {
            if let hasDifficulty = self.eventInfo?.eventActivity?.activityDificulty where hasDifficulty != "" {
                eventSubType = "\(eventSubType) - \(hasDifficulty)"
            }
            self.eventName.text = eventSubType
        }
        
        
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
                    if let eventDate = formatter.dateFromString(hasLaunchDate) {
                        if eventDate.isThisWeek() == true {
                            let time = eventDate.toString(format: .Custom(weekDayDateFormat()))
                            let timeAttributedStr = NSAttributedString(string: time, attributes: nil)
                            finalString.appendAttributedString(timeAttributedStr)
                        } else {
                            let time = eventDate.toString(format: .Custom(trDateFormat()))
                            let timeAttributedStr = NSAttributedString(string: time, attributes: nil)
                            finalString.appendAttributedString(timeAttributedStr)
                        }
                    }
                }
            }
            
            self.eventCheckPoint_Time?.attributedText = finalString
        } else if (self.eventInfo?.isFutureEvent == true){
            self.isFutureEvent = true
            
            if let hasLaunchDate = self.eventInfo?.eventLaunchDate {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                if let eventDate = formatter.dateFromString(hasLaunchDate) {
                    if eventDate.isThisWeek() == true {
                        let time = eventDate.toString(format: .Custom(weekDayDateFormat()))
                        let timeAttributedStr = NSAttributedString(string: time, attributes: nil)
                        self.eventCheckPoint_Time?.attributedText = timeAttributedStr
                    } else {
                        let time = eventDate.toString(format: .Custom(trDateFormat()))
                        let timeAttributedStr = NSAttributedString(string: time, attributes: nil)
                        self.eventCheckPoint_Time?.attributedText = timeAttributedStr
                    }
                }
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
        
        //Update Comment Count
        if let hasComments = self.eventInfo?.eventComments.count {
            let commentString = "COMMENTS (\(hasComments))"
            self.segmentControl?.setTitle(commentString, forSegmentAtIndex: 1)
        }
        
        //Title Placements
        if self.isFutureEvent == false {
            if (self.hasTag) {
            } else {
                self.titleHeightConstraint.constant = 175
                self.iconHeightConstraint.constant = 170
            }
        } else {
            if (self.hasTag) {
            } else {
                self.titleHeightConstraint.constant = 175
                self.iconHeightConstraint.constant = 170
            }
        }
        
        
        //Constraints
        if DeviceType.IS_IPHONE_6P == true {
            self.leftSectionUnderLineRightConstraint?.constant = 40
            self.rightSectionUnderLineLeftConstraint?.constant = 40
        } else {
            self.leftSectionUnderLineRightConstraint?.constant = 32
            self.rightSectionUnderLineLeftConstraint?.constant = 32
        }
        
        //Full Event View's Text Labels
        if TRApplicationManager.sharedInstance.currentUser?.userID != self.eventInfo?.eventCreator?.playerID {
            if let creatorTag = self.eventInfo?.eventCreator?.playerPsnID {
                self.fullViewsDescriptionLabel?.text = "Send \(creatorTag) a friend request or message for a party invite."
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.chatViewOriginalContentSize = self.chatTextView?.contentSize
        self.chatViewOriginalFrame = self.chatTextView?.frame

        TRApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentViewForDetailView(self, withEvent: self.eventInfo!)
        TRApplicationManager.sharedInstance.fireBaseManager?.addUserObserverWithView({ (didCompelete) in
            
        })
        
        
        self.showEventFullView()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove FireBase Observer
        if let _ = self.eventInfo {
            TRApplicationManager.sharedInstance.fireBaseManager?.removeDetailObserver(self.eventInfo!)
        }
        
        //Remove User Observer
        TRApplicationManager.sharedInstance.fireBaseManager?.removeUserObserver()
        
        
        //Remove FireBase Comment Observer
        TRApplicationManager.sharedInstance.fireBaseManager?.removeCommentsObserver(self.eventInfo!)
    }
    
    func reloadButton () {
        
        self.joinButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        self.chatTextBoxView?.hidden = true
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            let isCurrentUserInTheEvent = TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(self.eventInfo!)
            if isCurrentUserInTheEvent == true {
                self.joinButton.hidden = false
                self.joinButton?.backgroundColor = UIColor(red: 230/255, green: 178/255, blue: 0/255, alpha: 1)
                self.joinButton?.addTarget(self, action: #selector(leaveEvent(_:)), forControlEvents: .TouchUpInside)
                self.joinButton?.setTitle("LEAVE", forState: .Normal)
                self.tableViewBottomConstraint.constant = 0
            } else {
                if self.eventInfo?.eventPlayersArray.count == self.eventInfo?.eventMaxPlayers?.integerValue {
                    self.joinButton.hidden = true
                    self.tableViewBottomConstraint.constant = -(self.joinButton?.frame.size.height)!
                } else {
                    self.joinButton.hidden = false
                    self.joinButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
                    self.joinButton?.addTarget(self, action: #selector(joinAnEvent(_:)), forControlEvents: .TouchUpInside)
                    self.joinButton?.setTitle("JOIN", forState: .Normal)
                    self.tableViewBottomConstraint.constant = 0
                }
            }
        } else {
            self.tableViewScrollToBottom(true)
            let isCurrentUserInTheEvent = TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(self.eventInfo!)
            if isCurrentUserInTheEvent == true {
                self.chatTextBoxView?.hidden = false
                self.sendMessageButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                self.sendMessageButton.addTarget(self, action: #selector(sendMessage(_:)), forControlEvents: .TouchUpInside)
                self.tableViewBottomConstraint.constant = 0
            } else {
                if self.eventInfo?.eventPlayersArray.count == self.eventInfo?.eventMaxPlayers?.integerValue {
                    self.joinButton.hidden = true
                    self.tableViewBottomConstraint.constant = -(self.joinButton?.frame.size.height)!
                } else {
                    self.joinButton.hidden = false
                    self.joinButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
                    self.joinButton?.addTarget(self, action: #selector(joinAnEvent(_:)), forControlEvents: .TouchUpInside)
                    self.joinButton.setTitle("JOIN", forState: .Normal)
                    self.tableViewBottomConstraint.constant = 0
                }
            }
        }
    }
    
    //MARK:- IB_ACTIONS
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        if self.chatTextView?.isFirstResponder() == true {
            self.chatTextView.resignFirstResponder()
        }
    }
    
    @IBAction func dismissButton (sender: UIButton) {
        
        if self.chatTextView?.isFirstResponder() == true {
            self.chatTextView.resignFirstResponder()
        }
        
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }
    
    @IBAction func shareButton (sender: UIButton) {
        
        if let _ = self.eventInfo?.eventID {
            var myEventDict = [String: AnyObject]()
            myEventDict["eventId"] = self.eventInfo?.eventID
            _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(myEventDict, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_EVENT_SHARING, completion: {didSucceed in
                if didSucceed == true {
                }
            })
        }
        
        TRApplicationManager.sharedInstance.branchManager?.createLinkWithBranch(self.eventInfo!, deepLinkType: BRANCH_DEEP_LINKING_END_POINT.EVENT_DETAIL.rawValue, callback: {(url, error) in
            if (error == nil) {
                print(url)
                // Group to Share
                let groupToShare = [url] as [AnyObject]
                
                let activityViewController = UIActivityViewController(activityItems: groupToShare , applicationActivities: nil)
                self.presentViewController(activityViewController, animated: true, completion: {})
                activityViewController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
                    if (!completed) {
                        return
                    }
                }
            } else {
                print(String(format: "Branch TestBed: %@", error!))
            }
        })
    }
    
    @IBAction func segmentControlSelection (sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.segmentOneUnderLine?.hidden = false
            self.segmentTwoUnderLine?.hidden = true
            
            TRApplicationManager.sharedInstance.fireBaseManager?.removeCommentsObserver(self.eventInfo!)
            break;
        case 1:
            self.segmentOneUnderLine?.hidden = true
            self.segmentTwoUnderLine?.hidden = false
            
            TRApplicationManager.sharedInstance.fireBaseManager?.addCommentsObserversWithParentViewForDetailView(self, withEvent: self.eventInfo!)
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
            if let _ = self.eventInfo {
                return (self.eventInfo?.eventActivity?.activityMaxPlayers?.integerValue)!
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
                
                var playersNameString = self.eventInfo?.eventPlayersArray[indexPath.section].getDefaultConsole()?.consoleId!
                if var clanTag = self.eventInfo?.eventPlayersArray[indexPath.section].getDefaultConsole()?.clanTag! where clanTag != "" {
                    clanTag = " " + "[" + clanTag + "]"
                    if self.eventInfo?.eventPlayersArray[indexPath.section].playerID != TRApplicationManager.sharedInstance.currentUser?.userID {
                        playersNameString = playersNameString! + clanTag
                    } else if (TRUserInfo.isUserVerified()! == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                        playersNameString = playersNameString! + clanTag
                    }
                }
                
                cell?.playerUserName.text = playersNameString
                cell?.playerUserName?.textColor = UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)
                cell?.playerIcon.roundRectView (1, borderColor: UIColor.grayColor())
                cell?.playerInviteButton.hidden = true
                
                if self.eventInfo?.eventPlayersArray[indexPath.section].userVerified != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue
                && self.eventInfo?.eventPlayersArray[indexPath.section].playerID == TRApplicationManager.sharedInstance.currentUser?.userID{
                    cell?.playerIcon.image = UIImage(named: "default_helmet")
                } else {
                    if let hasImage = self.eventInfo?.eventPlayersArray[indexPath.section].playerImageUrl {
                        let imageURL = NSURL(string: hasImage)
                        cell?.playerIcon.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "default_helmet"))
                    }
                }
                
                return cell!
            } else {
                cell?.playerIcon?.image = UIImage(named: "iconProfileBlank")
                cell?.playerUserName?.text = "searching..."
                cell?.playerUserName?.textColor = UIColor.whiteColor()
                
                if (indexPath.section) == self.eventInfo?.eventPlayersArray.count {
                    cell?.playerInviteButton.hidden = false
                } else {
                    cell?.playerInviteButton.hidden = true
                }
                
                
                return cell!
            }
        } else {
            let commentCell: TREventCommentCell = (tableView.dequeueReusableCellWithIdentifier(EVENT_COMMENT_CELL) as? TREventCommentCell)!
            
            if self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userVerified != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue && self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userID == TRApplicationManager.sharedInstance.currentUser?.userID {
                commentCell.playerIcon.image = UIImage(named: "default_helmet")
            } else {
                if let hasImage = self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userImageURL! {
                    let imageURL = NSURL(string: hasImage)
                    commentCell.playerIcon.sd_setImageWithURL(imageURL)
                }
            }
            
            if self.eventInfo?.eventComments[indexPath.section].commentReported == true {
                commentCell.playerComment.text = "[comment removed]"
                commentCell.messageTopConst?.constant = -10
                commentCell.messageBottomConst?.constant = -10
            } else {
                //Check if User is part of the event && comment shouldnt be marked as Reported
                if let playerID = self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userID {
                    if self.eventInfo?.isUserPartOfEvent(playerID) == false {
                        commentCell.playerComment?.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)
                        commentCell.playerUserName?.textColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)
                        commentCell.playerIcon?.image = UIImage(named: "iconProfileBlank")
                    } else {
                        commentCell.playerComment?.textColor = UIColor.whiteColor()
                        commentCell.playerUserName?.textColor = UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)
                    }
                }
                
                commentCell.messageTopConst?.constant = 5
                commentCell.messageBottomConst?.constant = 0
                commentCell.playerComment.text = self.eventInfo?.eventComments[indexPath.section].commentText!
            }
            
            self.eventTable?.estimatedRowHeight = event_description_row_height
            self.eventTable?.rowHeight = UITableViewAutomaticDimension

            
            var playersNameString = self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.getDefaultConsole()?.consoleId!
            if var clanTag = self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.getDefaultConsole()?.clanTag where clanTag != "" {
                clanTag = " " + "[" + clanTag + "]"
                if self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userID != TRApplicationManager.sharedInstance.currentUser?.userID {
                    playersNameString = playersNameString! + clanTag
                } else if (TRUserInfo.isUserVerified()! == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                    playersNameString = playersNameString! + clanTag
                }
            }
            
            commentCell.playerUserName.text = playersNameString
            commentCell.playerIcon.roundRectView (1, borderColor: UIColor.grayColor())
            
            if let hasTime = self.eventInfo?.eventComments[indexPath.section].commentCreated {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                let updateDate = formatter.dateFromString(hasTime)
                updateDate!.relative()
                commentCell.messageTimeLabel?.text = updateDate!.relative()
            }
        
 
            if self.eventInfo?.eventComments[indexPath.section].commentReported == true {
                commentCell.playerIcon.image = UIImage(named: "accountCircle")
                commentCell.playerUserName.hidden = true
            } else {
                commentCell.playerUserName.hidden = false
            }
            
            //Add DogTag to the event creator
            if self.eventInfo?.eventFull() == true {
                if self.eventInfo?.eventComments[indexPath.section].commentUserInfo?.userID == self.eventInfo?.eventCreator?.playerID {
                    commentCell.creatorDogTag?.hidden = false
                } else {
                    commentCell.creatorDogTag?.hidden = true
                }
            }
            
            
            return commentCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if segmentControl?.selectedSegmentIndex == 1 {
            self.chatTextView.resignFirstResponder()
            
            if (self.eventInfo?.eventComments[indexPath.section].commentReported == true)  {
                return
            } else if (TRApplicationManager.sharedInstance.currentUser?.hasReachedMaxReportedComments == true) {
                self.selectedComment = self.eventInfo?.eventComments[indexPath.section]
                let errorView = NSBundle.mainBundle().loadNibNamed("TRCustomErrorUserAction", owner: self, options: nil)[0] as! TRCustomError
                errorView.errorMessageHeader?.text = "REPORT ISSUE"
                errorView.errorMessageDescription?.text = "Looks like you’ve sent several reports recently. This probably needs our attention! Please tell us more about this issue."
                errorView.frame = self.view.frame
                errorView.delegate = self
                
                self.view.addSubviewWithLayoutConstraint(errorView)
            } else {
                self.selectedComment = self.eventInfo?.eventComments[indexPath.section]
                let errorView = NSBundle.mainBundle().loadNibNamed("TRCustomErrorUserAction", owner: self, options: nil)[0] as! TRCustomError
                errorView.errorMessageHeader?.text = "REPORT ISSUE"
                errorView.errorMessageDescription?.text = "Is this comment problematic? Reporting it will hide it from everyone. Let us know more at support@crossroadsapp.co"
                errorView.frame = self.view.frame
                errorView.delegate = self
                
                self.view.addSubviewWithLayoutConstraint(errorView)
            }
        } else {
            if indexPath.section == self.eventInfo?.eventPlayersArray.count {
                let inviteView = NSBundle.mainBundle().loadNibNamed("TRInviteView", owner: self, options: nil)[0] as! TRInviteView
                inviteView.setUpView()
                inviteView.frame = CGRectMake(0, inviteView.bounds.size.height, inviteView.frame.size.width, inviteView.frame.size.height)
                let trans = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
                trans.fromValue = NSValue(CGPoint: CGPointMake(0, inviteView.bounds.size.height))
                trans.toValue = NSValue(CGPoint: CGPointMake(0, 0))
                inviteView.layer.pop_addAnimation(trans, forKey: "Translation")
                
                let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
                popAnimation.toValue = 1.0
                popAnimation.duration = 0.4
                inviteView.pop_addAnimation(popAnimation, forKey: "alphasIn")
                
                self.view.addSubviewWithLayoutConstraint(inviteView)
            }
        }
    }
    
    
    //Custom Error Delegate Method
    func customErrorActionButtonPressed() {
        
        guard let _ = self.selectedComment else { return }
        
        if TRApplicationManager.sharedInstance.currentUser?.hasReachedMaxReportedComments == true {
            let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let vc : TRSendReportViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as! TRSendReportViewController
            vc.isModallyPresented = true
            vc.eventID = self.eventInfo?.eventID
            vc.commentID = (self.selectedComment?.commentId)!
            
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.hidden = true
            self.presentViewController(navigationController, animated: true, completion: nil)
        } else {
            _ = TRReportComment().reportAComment((self.selectedComment?.commentId)!, eventID: (self.eventInfo?.eventID)!,reportDetail: nil, reportedEmail: nil, completion: { (didSucceed) in
                if didSucceed == true {
                    self.selectedComment = nil
                }
            })
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
            
            if self.segmentControl?.selectedSegmentIndex == 1 {
                self.tableViewScrollToBottom(false)
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
        
        if self.chatTextView.text.isEmpty == true {
            return
        }
        
        let trimmedString = self.chatTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
        if trimmedString.characters.count == 0 {
            return
        }
        
        if self.chatTextView?.isFirstResponder() == true {
            self.chatTextView.resignFirstResponder()
        }
        
        if let textMessage = self.chatTextView.text where textMessage != "Type your comment here" {
            _ = TRSendPushMessage().sendEventMessage((self.eventInfo?.eventID!)!, messageString: textMessage, completion: { (didSucceed) in
                if (didSucceed != nil)  {
                    
                    //Clear Text and reset Chat View
                    self.chatTextView?.contentSize = self.chatViewOriginalContentSize!
                    self.chatTextView?.frame = self.chatViewOriginalFrame!
                    self.textViewHeightConstraint.constant = 50
                    self.chatTextView.text = nil
                } else {
                }
            })
        }
    }
    
    //MARK:- Text View Methods
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.chatTextView.resignFirstResponder()
            self.sendMessage(self.sendMessageButton)
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let rows = (textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom) / textView.font!.lineHeight
        let myRowsInInt: Int = Int(rows)
        
        if (myRowsInInt > 1 && myRowsInInt <= 4) {
            let contentSizeHeight = textView.contentSize.height
            self.textViewHeightConstraint.constant = contentSizeHeight
            self.view.updateConstraints()
            
            self.tableViewScrollToBottom(true)
        }
        
        if textView.text == "" {
            self.textViewHeightConstraint.constant = 50
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
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
        
        self.hideEventFullView()
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        if self.view.frame.origin.y == self.view.frame.origin.y - keyboardSize.height {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height
            })
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.view.frame.origin.y = 0
            })
        }
        
        self.tableViewScrollToBottom(true)
        self.showEventFullView()
    }
    
    func showEventFullView () {
        if self.eventInfo?.eventFull() == true {
            UIView.animateWithDuration(0.5) {
                self.eventInfoTableTopConstraint?.constant = 94
                self.eventFullViewBottomConstraint?.constant = 94
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func hideEventFullView () {
        if self.eventInfo?.eventFull() == true {
            UIView.animateWithDuration(0.5) {
                self.eventInfoTableTopConstraint?.constant = 0
                self.eventFullViewBottomConstraint?.constant = 0
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    deinit {
        
    }
}