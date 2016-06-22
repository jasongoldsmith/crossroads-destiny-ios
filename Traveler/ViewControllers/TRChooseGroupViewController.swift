//
//  TRChooseGroupViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SlideMenuControllerSwift

private let GROUP_CELLS_IDENTIFIER = "groupCells"
private let MIN_DEFAULT_GROUPS = 0

class TRChooseGroupViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate {

    private var bungieGroups: [TRBungieGroupInfo] = []
    private var selectedGroup: TRBungieGroupInfo?
    private var highlightedCell: TRBungieGroupCell?
    
    var delegate: AnyObject?
    
    //To be hidden if there are no groups
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var lableOne: UILabel!
    @IBOutlet weak var lableThree: TTTAttributedLabel!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!

    //Selected Group View
    @IBOutlet weak var selectedGroupView: UIView!
    @IBOutlet weak var selectedGroupViewGroupImage: UIImageView!
    @IBOutlet weak var selectedGroupViewGroupName: UILabel!
    @IBOutlet weak var selectedGroupViewMemberCount: UILabel!
    @IBOutlet weak var selectedGroupViewEventCount: UILabel!
    @IBOutlet weak var selectedGroupViewNotificationButton: EventButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupsTableView?.registerNib(UINib(nibName: "TRBungieGroupCell", bundle: nil), forCellReuseIdentifier: GROUP_CELLS_IDENTIFIER)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if TRApplicationManager.sharedInstance.slideMenuController.isLeftOpen() == false {
            _ = TRGetAllDestinyGroups().getAllGroups({ (didSucceed) in
                if didSucceed == true {
                    //Fetch Groups
                    self.bungieGroups.removeAll()
                    self.bungieGroups = TRApplicationManager.sharedInstance.bungieGroups
                    
                    if TRApplicationManager.sharedInstance.bungieGroups.count <=  1 {
                        self.addNoneGroupCountUI()
                    } else {
                        self.lableThree.hidden = true
                        
                        //Add bottom border to GroupList Table
                        self.changeSaveButtonVisuals()
                    }
                    
                    
                    if let userGroup = TRUserInfo.getUserClanID() {
                        let selectedGroup = self.bungieGroups.filter{$0.groupId! == userGroup}
                        self.selectedGroup = selectedGroup.first
                        let groupIndex = self.bungieGroups.indexOf({$0.groupId == self.selectedGroup?.groupId})
                        if let _ = groupIndex {
                            self.bungieGroups.removeAtIndex(groupIndex!)
                        }
                        
                        //Add selected Group UI
                        self.addSelectedGroupUI()
                    }
                    
                    // Reload Data
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        UIView.transitionWithView(self.groupsTableView,
                            duration: 0.5,
                            options: .TransitionCrossDissolve,
                            animations:
                            { () -> Void in
                                self.groupsTableView.reloadData()
                                self.groupsTableView.setContentOffset(CGPointZero, animated:true)
                            },
                            completion: nil);
                    }
                }
            })
        }
    }

    func changeSaveButtonVisuals () {
        self.saveButton?.enabled = false
        self.saveButton?.titleLabel?.text = nil
        self.saveButton?.backgroundColor = UIColor(red: 35/255, green: 58/255, blue: 62/255, alpha: 1)
        
        self.saveButton.layer.shadowColor = UIColor.blackColor().CGColor;
        self.saveButton.layer.shadowOffset = CGSizeMake(3, 3);
        self.saveButton.layer.shadowRadius = 5;
        self.saveButton.layer.shadowOpacity = 1;
    }
    
    func addSelectedGroupUI () {
        
        if let hasImage = self.selectedGroup?.avatarPath {
            let imageUrl = NSURL(string: hasImage)
            self.selectedGroupViewGroupImage?.sd_setImageWithURL(imageUrl)
        }
        
        self.selectedGroupViewGroupName.text = self.selectedGroup?.groupName
        self.selectedGroupViewMemberCount.text = (self.selectedGroup?.memberCount?.description)! + " in Orbit"
        self.selectedGroupViewNotificationButton.selected = self.selectedGroup?.groupNotification?.boolValue == false ? true: false
        self.selectedGroupViewNotificationButton.addTarget(self, action: #selector(updateNotificationPreference), forControlEvents: .TouchUpInside)
        self.selectedGroupViewNotificationButton.buttonGroupInfo = self.selectedGroup
        
        if let eventCount = self.selectedGroup?.eventCount {
            self.selectedGroupViewEventCount.textColor = eventCount <= 0 ? UIColor.lightGrayColor() : UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)
            self.selectedGroupViewEventCount.text = eventCount.description + " Events"
        } else {
            self.selectedGroupViewEventCount.hidden = true
        }
        
        if let eventMembers = self.selectedGroup?.memberCount {
            self.selectedGroupViewMemberCount.text = eventMembers.description + " in Orbit"
        } else {
            self.selectedGroupViewMemberCount.hidden = true
        }
        
        
        self.selectedGroupView.backgroundColor = self.selectedGroup?.groupId == "clan_id_not_set" ? UIColor(red: 3/255, green: 81/255, blue: 102/255, alpha: 1) : UIColor(red: 19/255, green: 31/255, blue: 35/255, alpha: 1)
    }
    
    
    //MARK- Scroll Methods
    // Help to disable/ enable scroll in down-right direction. Disabling helps to let table view scroll and to let swipe gesture be disabled
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("Scroll")
        TRApplicationManager.sharedInstance.slideMenuController.rightPanGesture?.enabled = false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        TRApplicationManager.sharedInstance.slideMenuController.rightPanGesture?.enabled = true
    }
    
    func addNoneGroupCountUI () {
        self.lableThree.hidden = false
        
        let messageString = "It looks like you are not a member of any group. Feel free to Freelance with us or head to Bungie.net to join a group and fully experience the Crossroads for Destiny app."
        let bungieLinkName = "Bungie.net"
        self.lableThree?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.rangeOfString(bungieLinkName)
        let url = NSURL(string: "https://www.bungie.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        self.lableThree?.linkAttributes = subscriptionNoticeLinkAttributes
        self.lableThree?.addLinkToURL(url, withRange: range)
        self.lableThree?.delegate = self
    }
    
    //MARK:- Table Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return bungieGroups.count
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
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GROUP_CELLS_IDENTIFIER) as! TRBungieGroupCell
        if indexPath.section < self.bungieGroups.count {
            let groupInfo = self.bungieGroups[indexPath.section]
            cell.selectionStyle = .None
            cell.updateCellViewWithGroup(groupInfo)
            cell.userInteractionEnabled = true
            cell.notificationButton.buttonGroupInfo = groupInfo
            cell.notificationButton.addTarget(self, action: #selector(updateNotificationPreference), forControlEvents: .TouchUpInside)
            cell.notificationButton.selected = groupInfo.groupNotification?.boolValue == false ? true: false
        } else {
            cell.userInteractionEnabled = false
            cell.overlayImageView.hidden = false
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedGroup = self.bungieGroups[indexPath.section]
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? TRBungieGroupCell
        self.highlightedCell = cell
       
        if let group = self.selectedGroup {
            _ = TRUpdateGroupRequest().updateUserGroup(group.groupId!, completion: { (didSucceed) in
                _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: false, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
                    if(didSucceed == true) {
                        if let del = self.delegate as? TREventListViewController {
                            del.reloadEventTable()
                        }
                        
                        TRApplicationManager.sharedInstance.slideMenuController.closeRight()
                    }
                })
            })
        }
    }

    //MARK:- UpdateNotification Request
    func updateNotificationPreference(sender: EventButton) {
        
        if let hasGroupId = sender.buttonGroupInfo?.groupId {
            _ = TRGroupNotificationUpdateRequest().updateUserGroupNotification(hasGroupId, completion: { (didSucceed) in
                if didSucceed == true {
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.groupsTableView.reloadData()
                    })
                }
            })
        }
    }

    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }

    
    @IBAction func goToBungieWebSite (sender: UIButton) {
        let url = NSURL(string: "https://www.bungie.net/")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    deinit {
        
    }
}
