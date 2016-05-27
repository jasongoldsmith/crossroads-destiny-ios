//
//  TRChooseGroupViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel

private let GROUP_CELLS_IDENTIFIER = "groupCells"

class TRChooseGroupViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate {

    private var bungieGroups = TRApplicationManager.sharedInstance.bungieGroups
    private var selectedGroup: TRBungieGroupInfo?
    private var highlightedCell: TRBungieGroupCell?
    
    var delegate: AnyObject?
    
    //To be hidden if there are no groups
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var lableOne: UILabel!
    @IBOutlet weak var lableTwo: UILabel!
    @IBOutlet weak var lableThree: TTTAttributedLabel!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupsTableView?.registerNib(UINib(nibName: "TRBungieGroupCell", bundle: nil), forCellReuseIdentifier: GROUP_CELLS_IDENTIFIER)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if TRApplicationManager.sharedInstance.bungieGroups.count <= 1 {
            self.addNoneGroupCountUI()
        } else {
            self.lableThree.hidden = true
            self.saveButton.hidden = true
        }
        
        
        if let userGroup = TRUserInfo.getUserClanID() where userGroup != "clan_id_not_set" {
            let selectedGroup = self.bungieGroups.filter{$0.groupId! == userGroup}
            self.selectedGroup = selectedGroup.first
            let groupIndex = self.bungieGroups.indexOf({$0.groupId == self.selectedGroup?.groupId})
            if let _ = groupIndex {
                self.bungieGroups.removeAtIndex(groupIndex!)
                self.bungieGroups.insert(self.selectedGroup!, atIndex: 0)
            }
        }

        
        self.groupsTableView.reloadData()
    }
    
    func addNoneGroupCountUI () {
        self.lableThree.hidden = false
        
        let messageString = "It looks like you are not a member of any group. Feel free to Freelance with us or head to Bungie.net to join a group and fully experience the Crossroad for Destiny app."
        let bungieLinkName = "Bungie.net"
        self.lableThree?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.rangeOfString(bungieLinkName)
        let url = NSURL(string: "https://www.bungie.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:false),
            ]
        self.lableThree?.linkAttributes = subscriptionNoticeLinkAttributes
        self.lableThree?.addLinkToURL(url, withRange: range)
        self.lableThree?.delegate = self

    }
    
    //MARK:- Table Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if TRApplicationManager.sharedInstance.bungieGroups.count <= 1 {
            return 2
        }
        
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
      
        if let userGroup = TRUserInfo.getUserClanID() where userGroup == "clan_id_not_set" {
            return 6
        }
        
        if section == 1 {
            return 15
        }
        
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GROUP_CELLS_IDENTIFIER) as! TRBungieGroupCell
        if indexPath.section < self.bungieGroups.count {
            let groupInfo = self.bungieGroups[indexPath.section]
            cell.selectionStyle = .None
            cell.updateCellViewWithGroup(groupInfo)
            
            if let hasCurrentGroup = TRUserInfo.getUserClanID() {
                if hasCurrentGroup == groupInfo.groupId {
                    self.highlightedCell = cell
                    cell.bottomBorderImageView.hidden = false
                    cell.radioButton?.highlighted = true
                }
            }
        } else {
            cell.userInteractionEnabled = false
            cell.overlayImageView.hidden = false
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        

        if let _ = self.highlightedCell {
            self.highlightedCell?.radioButton?.highlighted = false
        }

        self.selectedGroup = self.bungieGroups[indexPath.section]
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? TRBungieGroupCell
        self.highlightedCell = cell
        cell?.radioButton?.highlighted = true
        
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
