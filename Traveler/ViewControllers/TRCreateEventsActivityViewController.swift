//
//  TRCreateEventsActivityViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/7/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRCreateEventsActivityViewController: TRBaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var seletectedActivity : TRActivityInfo?
    var activitiesOfSelectedType: [TRActivityInfo] = []
    
    var activitySubTypeOfDifferentType : [TRActivityInfo] = []
    
    @IBOutlet var pickerOne: UIPickerView?
    @IBOutlet var createEventButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ADD NAVIGATION BAR BUTTON
        addNavigationBarButtons()
        
        
        // Get all Activities of selected activityType
        self.activitiesOfSelectedType       = TRApplicationManager.sharedInstance.getActivitiesOfType((self.seletectedActivity?.activityType)!)!
        
        // Get all of Individual Type activities of ActivitySubType
        if let arrayWithSeperateSubActivities = self.getActivitiesOfDifferentSubType(self.activitiesOfSelectedType) {
            self.activitySubTypeOfDifferentType = arrayWithSeperateSubActivities
        }
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

    func backButtonPressed (sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func createEventButtonTapped (sender: UIButton) {
        
        _ = TRCreateEventRequest().createAnEvent({ (value) -> () in
            if (value == true) {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                })
            } else {
                self.appManager.log.debug("Create Event Failed")
            }
        })
    }
    
    //#MARK:- PICKER_VIEW
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.activitySubTypeOfDifferentType.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.activitiesOfSelectedType[row].activitySubType
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        appManager.log.debug("\(self.activitiesOfSelectedType[row].activityID!)")
    }
    
    deinit {
        appManager.log.debug("")
    }
}

