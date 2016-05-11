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
    
    //Show Featured Events
    var isFeaturedEvent: Bool = false
    
    // Contains Activities of only "selected" type
    var filteredActivitiesOfSelectedType: [TRActivityInfo] = []

    // Contains Unique Activities Based on SubType/ Difficulty
    var filteredActivitiesOfSubTypeAndDifficulty: [TRActivityInfo] = []
    
    @IBOutlet weak var activityIconImage: UIImageView!
    @IBOutlet weak var activitySelectionTable: UITableView!
    @IBOutlet weak var activityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isFeaturedEvent == false {
            // Get all Activities of selected activityType
            self.filteredActivitiesOfSelectedType = TRApplicationManager.sharedInstance.getActivitiesOfType((self.seletectedActivity?.activityType)!)!
            // Get All activities filtered on Difficulty and SubType
            self.filteredActivitiesOfSubTypeAndDifficulty = self.getFiletreObjOfSubTypeAndDifficulty()!
        } else {
            self.filteredActivitiesOfSelectedType = TRApplicationManager.sharedInstance.getFeaturedActivities()!
            self.filteredActivitiesOfSubTypeAndDifficulty = self.getFiletreObjOfSubTypeAndDifficulty()!
        }

        
        //Register Cell Nib
        self.activitySelectionTable?.registerNib(UINib(nibName: "TRActivitySelectionCell", bundle: nil), forCellReuseIdentifier: ACTIVITY_SELECTION_CELL)
        self.activitySelectionTable?.tableFooterView = UIView(frame: CGRectZero)


        //IMAGE VIEW
        
        if let imageUrlString = seletectedActivity?.activityIconImage {
            let imageURL = NSURL(string: imageUrlString)
            self.activityIconImage?.sd_setImageWithURL(imageURL)
            self.activityIconImage?.roundRectView(2.0)
        }
        
        // Activity Name Label
        self.activityNameLabel?.text = self.seletectedActivity?.activityType
        
        
        // Set seperator clear color
        self.activitySelectionTable.separatorColor = UIColor.clearColor()
        
        //Navigation
        self.title = "CREATE EVENT"
        self.addNavigationBarButtons()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
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
        
        return self.filteredActivitiesOfSubTypeAndDifficulty.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ACTIVITY_SELECTION_CELL) as! TRActivitySelectionCell
        cell.updateCell(self.filteredActivitiesOfSubTypeAndDifficulty[indexPath.section])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.activitySelectionTable?.deselectRowAtIndexPath(indexPath, animated: false)
        
        let vc = TRApplicationManager.sharedInstance.stroryBoardManager.getViewControllerWithID(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CREATE_EVENT_CONFIRM, storyBoardID: K.StoryBoard.StoryBoard_Main) as! TRCreateEventConfirmationViewController
        vc.selectedActivity = self.filteredActivitiesOfSubTypeAndDifficulty[indexPath.section]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK:- DATA METHODS
    func getFiletreObjOfSubTypeAndDifficulty () -> [TRActivityInfo]? {

        var filteredArray: [TRActivityInfo] = []
        for (_, activity) in self.filteredActivitiesOfSelectedType.enumerate() {
            if (self.filteredActivitiesOfSelectedType.count < 1) {
                filteredArray.append(activity)
            } else {
                let activityArray = filteredArray.filter {$0.activityDificulty == activity.activityDificulty && $0.activitySubType == activity.activitySubType}
                if (activityArray.count == 0) {
                    filteredArray.append(activity)
                }
            }
        }
        
        return filteredArray
    }
    
    
    deinit {
        appManager.log.debug("")
    }
}