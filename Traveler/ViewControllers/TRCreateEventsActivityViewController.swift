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
    
    var seletectedActivity             : TRActivityInfo?
    var activitiesOfSelectedType       : [TRActivityInfo] = []
    var activitiesCheckPoints          : [TRActivityInfo] = []
    var activitySubTypeOfDifferentType : [TRActivityInfo] = []
    
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
        if let arrayWithSeperateSubActivities = self.getActivitiesOfDifferentSubType(self.activitiesOfSelectedType) {
            self.activitySubTypeOfDifferentType = arrayWithSeperateSubActivities
        }
        
        self.activitiesCheckPoints = self.getActivitiesCheckPointsForTheSelectedActivity(self.activitySubTypeOfDifferentType[0])
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
    func getActivitiesOfDifferentSubType (activityArray: [TRActivityInfo]) -> [TRActivityInfo]? {
        
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

    func getActivitiesCheckPointsForTheSelectedActivity (activity: TRActivityInfo) -> [TRActivityInfo] {
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
            return self.activitySubTypeOfDifferentType.count
        } else if (pickerView == self.pickerTwo) {
            return self.activitiesCheckPoints.count
        }

        return self.activitiesCheckPoints.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.pickerOne {
            return self.activitySubTypeOfDifferentType[row].activitySubType
        } else if (pickerView == self.pickerTwo) {
            return self.activitiesCheckPoints[row].activityCheckPoint
        }
        
        return self.activitiesCheckPoints[row].activityCheckPoint
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.pickerOne {
            if (self.activitySubTypeOfDifferentType[row].activityID) != nil {
                self.activitiesCheckPoints = self.getActivitiesCheckPointsForTheSelectedActivity(self.activitySubTypeOfDifferentType[row])
                
                self.pickerTwo?.reloadAllComponents()
                
                self.pickerTwo!.selectRow(0, inComponent: 0, animated: false)
                self.pickerView(self.pickerTwo!, didSelectRow: 0, inComponent: 0)
            }
        }
    }
    
    deinit {
        appManager.log.debug("")
    }
}

