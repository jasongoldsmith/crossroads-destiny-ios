//
//  TRChooseGroupViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

private let GROUP_CELLS_IDENTIFIER = "groupCells"

class TRChooseGroupViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate {

    private let bungieGroups = TRApplicationManager.sharedInstance.bungieGroups
    private var selectedGroup: TRBungieGroupInfo?
    private var highlightedCell: TRBungieGroupCell?
    
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groupsTableView?.registerNib(UINib(nibName: "TRBungieGroupCell", bundle: nil), forCellReuseIdentifier: GROUP_CELLS_IDENTIFIER)
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
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
                self.dismissViewController(true, dismissed: { (didDismiss) in
                    
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
