//
//  TRCreateEventSelectionViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/9/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

private let ACTIVITY_SELECTION_CELL = "activitySelectionCell"
private let ACTIVITY_TABLE_HEADER_HEIGHT:CGFloat = 10.0

class TRCreateEventSelectionViewController: TRBaseViewController {

    // Contains all the activities
    var seletectedActivity: TRActivityInfo?
    
    // Contains Activities of only "selected" type
    var filteredActivitiesOfSelectedType: [TRActivityInfo] = []

    
    @IBOutlet weak var activityIconImage: UIImageView!
    @IBOutlet weak var activitySelectionTable: UITableView!
    @IBOutlet weak var activityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ADD NAVIGATION BAR BUTTON
        addNavigationBarButtons()
     
        // Get all Activities of selected activityType
        self.filteredActivitiesOfSelectedType = TRApplicationManager.sharedInstance.getActivitiesOfType((self.seletectedActivity?.activityType)!)!

        //Register Cell Nib
        self.activitySelectionTable?.registerNib(UINib(nibName: "TRActivitySelectionCell", bundle: nil), forCellReuseIdentifier: ACTIVITY_SELECTION_CELL)
        self.activitySelectionTable?.tableFooterView = UIView(frame: CGRectZero)


        //IMAGE VIEW
        let imageUrl = NSURL(string: (seletectedActivity?.activityIconImage)!)
        self.activityIconImage.sd_setImageWithURL(imageUrl)
        
        // Activity Name Label
        self.activityNameLabel?.text = self.seletectedActivity?.activityType
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addNavigationBarButtons () {
        
        //Add Title
        self.title = "CREATE EVENT"
        
        //Adding Back Button to nav Bar
        let leftButton = UIButton(frame: CGRectMake(0,0,30,30))
        leftButton.setImage(UIImage(named: "iconBackArrow"), forState: .Normal)
        leftButton.addTarget(self, action: Selector("backButtonPressed:"), forControlEvents: .TouchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = leftButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }

    //MARK:- UI-ACTIONS
    func backButtonPressed (sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    //MARK:- UI-Table Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        return ACTIVITY_TABLE_HEADER_HEIGHT
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.filteredActivitiesOfSelectedType.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ACTIVITY_SELECTION_CELL) as! TRActivitySelectionCell
        cell.updateCell(self.filteredActivitiesOfSelectedType[indexPath.section])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.activitySelectionTable?.deselectRowAtIndexPath(indexPath, animated: false)
        
        let vc = TRApplicationManager.sharedInstance.stroryBoardManager.getViewControllerWithID(K.ViewControllerIdenifier.VIEW_CONTROLLER_CREATE_EVENT_CONFIRM, storyBoardID: K.StoryBoard.StoryBoard_Main) as! TRCreateEventConfirmationViewController
        vc.selectedActivity = self.filteredActivitiesOfSelectedType[indexPath.section]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    deinit {
        appManager.log.debug("")
    }
}