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

    private let bungieGroups = TRApplicationManager.sharedInstance.bungieGroups
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
        
        if TRApplicationManager.sharedInstance.bungieGroups.count <= 0 {
            self.saveButton.hidden = true
            self.groupsTableView.hidden = true
            self.lableOne.hidden = true
            self.lableTwo.hidden = true
            
            self.appIcon.image = UIImage(named: "imgNogroups")
            self.lableThree.hidden = false
            
            let messageString = "Traveler for Destiny matched you with people from your existing Bungie.net groups. \n \nIt looks like you're not a member of any groups. Please join a group in order to fully experience the app."
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
            
            return
        }
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GROUP_CELLS_IDENTIFIER) as! TRBungieGroupCell
        let groupInfo = self.bungieGroups[indexPath.section]
        cell.selectionStyle = .None
        cell.updateCellViewWithGroup(groupInfo)
        
        
        if let hasCurrentGroup = TRUserInfo.getUserClanID() {
            if hasCurrentGroup == groupInfo.groupId {
                self.highlightedCell = cell
                cell.radioButton?.highlighted = true
            }
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //self.saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.selectedGroup = self.bungieGroups[indexPath.section]
        self.saveButton.enabled = true
        self.saveButton.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        
        
        if let _ = self.highlightedCell {
            self.highlightedCell?.radioButton?.highlighted = false
        }

        let cell = tableView.cellForRowAtIndexPath(indexPath) as? TRBungieGroupCell
        self.highlightedCell = cell
        cell?.radioButton?.highlighted = true
    }
    
    @IBAction func saveButtonPressed (sender: UIButton) {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
    }
}
