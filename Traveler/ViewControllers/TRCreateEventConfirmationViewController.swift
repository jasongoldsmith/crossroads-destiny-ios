//
//  TRCreateEventConfirmationViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/9/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import AFDateHelper

private let PICKER_COMPONET_COUNT = 1

class TRCreateEventConfirmationViewController: TRBaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var activityIconImage: UIImageView?
    @IBOutlet weak var buttonOne: UIButton?
    @IBOutlet weak var buttonTwo: UIButton?
    @IBOutlet weak var buttonThress: UIButton?
    @IBOutlet weak var datePickerView: UIDatePicker?
    @IBOutlet weak var datePickerBackgroundImage: UIImageView?
    
    // Constraints OutLet
    @IBOutlet weak var buttonThreeTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var buttonThreeBottomConstraint: NSLayoutConstraint?
    
    var selectedActivity: TRActivityInfo?
    var similarActivitiesDifferentCheckPoints: [TRActivityInfo]?
    var checkpointPickerView: TRActivityCheckPointPicker! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Navigation Buttons
        self.addNavigationBarButtons()
        
        // Add Icon Image
        let imageUrl = NSURL(string: (self.selectedActivity?.activityIconImage)!)
        self.activityIconImage?.sd_setImageWithURL(imageUrl)
        
        // DatePicker BackGround
        self.datePickerView?.backgroundColor = UIColor.whiteColor()
        self.datePickerView?.layer.cornerRadius = 5
        self.datePickerView?.layer.masksToBounds = true
        
        // Add Tap Gesture to Date PickerBackGround ImageView
        let datePickerGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("datePickerimageTapped:"))
        self.datePickerBackgroundImage?.userInteractionEnabled = true
        self.datePickerBackgroundImage?.addGestureRecognizer(datePickerGestureRecognizer)

        //Get similar activities with different CheckPoints
        self.similarActivitiesDifferentCheckPoints = TRApplicationManager.sharedInstance.getActivitiesMatchingSubTypeAndLevel(self.selectedActivity!)
        
        
        
        
        //Check if Checkpoint are availble or not, if no checkPoints avaliable then just hide the whole UI Button Element
        if let _ = self.selectedActivity?.activityCheckPoint where self.selectedActivity?.activityCheckPoint != "" {
        
            //Add Checkpoint PickerView
            self.addCheckpointPickerView()
        } else {

            self.buttonTwo?.hidden = true
            self.buttonThreeTopConstraint?.constant = 40.0
            self.buttonThreeBottomConstraint?.constant = 300.0
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addCheckpointPickerView () {
        
        self.checkpointPickerView = NSBundle.mainBundle().loadNibNamed("TRActivityCheckPointPicker", owner: self, options: nil)[0] as! TRActivityCheckPointPicker
        self.checkpointPickerView.frame = self.view.bounds
        self.checkpointPickerView.pickerView.dataSource = self
        self.checkpointPickerView.pickerView.delegate   = self
        self.checkpointPickerView?.alpha = 0
        
        // Add Tap Gesture to Date PickerBackGround ImageView
        let checkPointPickerGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("checkPointPickerimageTapped"))
        self.checkpointPickerView?.imageView?.userInteractionEnabled = true
        self.checkpointPickerView?.imageView?.addGestureRecognizer(checkPointPickerGestureRecognizer)

        //Add Target to Done Button
        //self.checkpointPickerView?.doneButton.addTarget(self, action: "checkPointPickerimageTapped", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.checkpointPickerView)
    }
    
    func addNavigationBarButtons () {
        
        //Adding Back Button to nav Bar
        let leftButton = UIButton(frame: CGRectMake(0,0,30,30))
        leftButton.setImage(UIImage(named: "iconBackArrow"), forState: .Normal)
        leftButton.addTarget(self, action: Selector("backButtonPressed"), forControlEvents: .TouchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = leftButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        var labelSting = (self.selectedActivity?.activitySubType!)! + " - " + (self.selectedActivity?.activityDificulty!)! + " "
        if let light = self.selectedActivity?.activityLight?.integerValue where light > 0 {
            labelSting = labelSting + (self.selectedActivity!.activityLight?.stringValue)! + " Light"
        }
        
        self.buttonOne?.setTitle(labelSting, forState: .Normal)
        self.buttonTwo?.setTitle("Checkpoint - " + (self.selectedActivity?.activityCheckPoint!)!, forState: .Normal)
        self.buttonThress?.setTitle("Start Time - Now", forState: .Normal)
        
        self.buttonOne?.layer.cornerRadius = 5
        self.buttonTwo?.layer.cornerRadius = 5
        self.buttonThress?.layer.cornerRadius = 5
        self.buttonOne?.layer.masksToBounds = true
        self.buttonTwo?.layer.masksToBounds = true
        self.buttonThress?.layer.masksToBounds = true
    }
    
    //MARK:- UI-ACTIONS
    @IBAction func backButtonPressed () {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func changeDateButtonPressed (sender: UIButton) {
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.datePickerView?.alpha = 1
            self.datePickerBackgroundImage?.alpha = 0.5
        }
    }
    
    @IBAction func changeCheckPoint () {

        UIView.animateWithDuration(0.4) { () -> Void in
            self.checkpointPickerView?.alpha = 1
        }
    }
    
    @IBAction func createEvent () {
        let _ = TRCreateEventRequest().createAnEventWithActivity(self.selectedActivity!) { (value) -> () in
            if (value == true) {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.didMoveToParentViewController(nil)
                    self.removeFromParentViewController()
                })
            } else {
                self.appManager.log.debug("Create Event Failed")
            }
        }
    }

    @IBAction func datePickerValueChanged (sender: UIDatePicker) {
    
    }
    
    // Tapping on Date Picker Image Background will close the date-picker view
    func datePickerimageTapped(sender: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.datePickerView?.alpha = 0
            self.datePickerBackgroundImage?.alpha = 0
        }
        
        var timeString = ""
        let choosenDate = self.datePickerView?.date
        if ((choosenDate?.isToday()) == true) {
            timeString = "Start Time - Now"
        } else if ((choosenDate?.isTomorrow()) == true) {
            timeString = "Start Time - Tomorrow"
        } else {
            timeString = (choosenDate?.toString(dateStyle: .ShortStyle, timeStyle: .ShortStyle))!
        }
        
        self.buttonThress?.setTitle(timeString, forState: .Normal)
    }
    
    func checkPointPickerimageTapped () {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.checkpointPickerView?.alpha = 0
            
            let selectedIndex = self.checkpointPickerView?.pickerView.selectedRowInComponent(0)
            if let index = selectedIndex {
                self.selectedActivity = self.similarActivitiesDifferentCheckPoints?[index]
                
                var labelSting = (self.selectedActivity?.activitySubType!)! + " - " + (self.selectedActivity?.activityDificulty!)! + " "
                if let light = self.selectedActivity?.activityLight?.integerValue where light > 0 {
                    labelSting = labelSting + (self.selectedActivity!.activityLight?.stringValue)! + " Light"
                }

                self.buttonOne?.setTitle(labelSting, forState: .Normal)
                self.buttonTwo?.setTitle("Checkpoint - " + (self.selectedActivity?.activityCheckPoint!)!, forState: .Normal)
            }
        }
    }
    
    //#MARK:- PICKER_VIEW
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return PICKER_COMPONET_COUNT
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.similarActivitiesDifferentCheckPoints?.count)!
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.similarActivitiesDifferentCheckPoints?[row].activityCheckPoint
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

    
    deinit {
        appManager.log.debug("")
    }
}