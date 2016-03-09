//
//  TRCreateEventsActivityViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/7/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

private let PICKER_COLUMN_COUNT = 1

class TRCreateEventsActivityViewController: TRBaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Contains all the activities
    var seletectedActivity             : TRActivityInfo?
    
    // Contains Activities of only "selected" type
    var activitiesOfSelectedType       : [TRActivityInfo] = []
    
    //Contains Unique Activity Type
    var activityUniqueSubType          : [TRActivityInfo] = []
    
    //Contains all checkPoints for a certain ActivityType
    var activitiesCheckPoints          : [TRActivityInfo] = []

    //Contains all Unique checkPoints for a certain ActivityType
    var activitiesUniqueCheckPoints     : [TRActivityInfo] = []

    
    @IBOutlet var pickerOne: UIPickerView?
    @IBOutlet var pickerTwo: UIPickerView?
    @IBOutlet var createEventButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ADD NAVIGATION BAR BUTTON
        addNavigationBarButtons()
        
        
        // Get all Activities of selected activityType
        self.activitiesOfSelectedType = TRApplicationManager.sharedInstance.getActivitiesOfType((self.seletectedActivity?.activityType)!)!
        
        // Get all of Individual Type activities of ActivitySubType
        if let arrayWithSeperateSubActivities = self.getUniqueActivitiesOfSubType(self.activitiesOfSelectedType) {
            self.activityUniqueSubType = arrayWithSeperateSubActivities
        }
        
        self.activitiesCheckPoints = self.getActivitiesCheckPointsForTheSelectedActivity(self.activityUniqueSubType[0])!
        self.activitiesUniqueCheckPoints = self.getUniqueCheckPoints(self.activitiesCheckPoints)!
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
    }
    
    func addNavigationBarButtons () {

        //Adding Back Button to nav Bar
        let leftButton = UIButton(frame: CGRectMake(0,0,30,30))
        leftButton.setImage(UIImage(named: "iconBackArrow"), forState: .Normal)
        leftButton.addTarget(self, action: Selector("backButtonPressed:"), forControlEvents: .TouchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = leftButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    
    // Loop through received activities and eliminate activities with same "activitySubType"
    func getUniqueActivitiesOfSubType (activityArray: [TRActivityInfo]) -> [TRActivityInfo]? {
        
        var newIndivdualActivityArray: [TRActivityInfo] = []
        
        for(_, activity) in activitiesOfSelectedType.enumerate() {
            if (newIndivdualActivityArray.count == 0) {
                newIndivdualActivityArray.append(activity)
            } else {
                let activityArray = newIndivdualActivityArray.filter {$0.activitySubType == activity.activitySubType}
                if (activityArray.count == 0) {
                    newIndivdualActivityArray.append(activity)
                }
            }
        }
        
        return newIndivdualActivityArray
    }

    func getUniqueCheckPoints (activity: [TRActivityInfo]) -> [TRActivityInfo]? {
        var newUniqueCheckPoints: [TRActivityInfo] = []
        
        for(_, activity) in activity.enumerate() {
            if (newUniqueCheckPoints.count == 0) {
                newUniqueCheckPoints.append(activity)
            } else {
                let activityArray = newUniqueCheckPoints.filter {$0.activitySubType == activity.activitySubType}
                if (activityArray.count == 0) {
                    newUniqueCheckPoints.append(activity)
                }
            }
        }
        
        return newUniqueCheckPoints
    }
    
    func getActivitiesCheckPointsForTheSelectedActivity (activity: TRActivityInfo) -> [TRActivityInfo]? {
        return self.activitiesOfSelectedType.filter {$0.activitySubType == activity.activitySubType}
    }
    
    func backButtonPressed (sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func createEventButtonTapped (sender: UIButton) {
        
        _ = TRCreateEventRequest().createAnEvent({ (value) -> () in
            if (value == true) {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.didMoveToParentViewController(nil)
                    self.removeFromParentViewController()
                })
            } else {
                self.appManager.log.debug("Create Event Failed")
            }
        })
    }
    
    //#MARK:- PICKER_VIEW
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return PICKER_COLUMN_COUNT
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == self.pickerOne {
            return self.activityUniqueSubType.count
        } else if (pickerView == self.pickerTwo) {
            return self.activitiesUniqueCheckPoints.count
        }

        return self.activitiesUniqueCheckPoints.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.pickerOne {
            return self.activityUniqueSubType[row].activitySubType
        } else if (pickerView == self.pickerTwo) {
            return self.activitiesUniqueCheckPoints[row].activityCheckPoint
        }
        
        return self.activitiesUniqueCheckPoints[row].activityCheckPoint
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.pickerOne {
            if (self.activityUniqueSubType[row].activityID) != nil {
                
                self.activitiesCheckPoints = self.getActivitiesCheckPointsForTheSelectedActivity(self.activityUniqueSubType[row])!
                self.activitiesUniqueCheckPoints = self.getUniqueCheckPoints(self.activitiesCheckPoints)!
                
                self.pickerTwo?.reloadAllComponents()
                self.pickerTwo!.selectRow(0, inComponent: 0, animated: true)
                self.pickerView(self.pickerTwo!, didSelectRow: 0, inComponent: 0)
            }
        }
    }
    
    deinit {
        appManager.log.debug("")
    }
}

