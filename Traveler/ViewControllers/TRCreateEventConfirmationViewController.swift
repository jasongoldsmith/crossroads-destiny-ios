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
private let CURRENT_TIME_THREASHOLD = 1

class TRCreateEventConfirmationViewController: TRBaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var activityIconImage: UIImageView?
    @IBOutlet weak var buttonOne: UIButton?
    @IBOutlet weak var buttonTwo: UIButton?
    @IBOutlet weak var buttonThress: UIButton?
    @IBOutlet weak var datePickerView: UIDatePicker?
    @IBOutlet weak var datePickerBackgroundImage: UIImageView?
    @IBOutlet weak var eventTitleLabel: UILabel?
    @IBOutlet weak var buttonTwoNextIconImage: UIImageView?
    @IBOutlet weak var buttonThreeNextIconImage: UIImageView?
    
    // Constraints OutLet
    @IBOutlet weak var buttonThreeTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var buttonThreeBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var buttonTwoNextIconTopConstraint: NSLayoutConstraint?
    
    var selectedActivity: TRActivityInfo?
    var similarActivitiesDifferentCheckPoints: [TRActivityInfo]?
    var checkpointPickerView: TRActivityCheckPointPicker! = nil
    var selectedDate: NSDate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Add Icon Image
        let imageUrl = NSURL(string: (self.selectedActivity?.activityIconImage)!)
        self.activityIconImage?.sd_setImageWithURL(imageUrl)
        
        // DatePicker BackGround
        self.datePickerView?.backgroundColor = UIColor.whiteColor()
        self.datePickerView?.layer.cornerRadius = 5
        self.datePickerView?.layer.masksToBounds = true
        self.datePickerView?.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 30);
        self.datePickerView?.minimumDate = NSDate()
        
        // Add Tap Gesture to Date PickerBackGround ImageView
        let datePickerGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TRCreateEventConfirmationViewController.datePickerimageTapped(_:)))
        self.datePickerBackgroundImage?.userInteractionEnabled = true
        self.datePickerBackgroundImage?.addGestureRecognizer(datePickerGestureRecognizer)

        //Get similar activities with different CheckPoints
        self.similarActivitiesDifferentCheckPoints = TRApplicationManager.sharedInstance.getActivitiesMatchingSubTypeAndLevel(self.selectedActivity!)
        
        
        //Check if Checkpoint are availble or not, if no checkPoints avaliable then just hide the whole UI Button Element
        if let _ = self.selectedActivity?.activityCheckPoint where self.selectedActivity?.activityCheckPoint != "" {
        
            //Add Checkpoint PickerView
            self.addCheckpointPickerView()
        } else {
            self.buttonTwoNextIconTopConstraint?.constant = 55.0
            self.buttonThreeTopConstraint?.constant = -50.0
            
            self.buttonTwo?.hidden = true
            self.buttonThreeNextIconImage?.hidden = true
        }
        
        // Add Event Title
        self.eventTitleLabel?.text = self.selectedActivity?.activityType
        
        //Init selected Date as nil
        self.selectedDate = nil
        
        //Add Buttons
        self.addButtons()
        
        //Navigation
        self.title = "CREATE EVENT"
        self.addNavigationBarButtons()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func goBack () {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addCheckpointPickerView () {
        
        self.checkpointPickerView = NSBundle.mainBundle().loadNibNamed("TRActivityCheckPointPicker", owner: self, options: nil)[0] as! TRActivityCheckPointPicker
        self.checkpointPickerView.frame = self.view.bounds
        self.checkpointPickerView.pickerView.dataSource = self
        self.checkpointPickerView.pickerView.delegate   = self
        self.checkpointPickerView?.alpha = 0
        
        // Add Tap Gesture to Date PickerBackGround ImageView
        let checkPointPickerGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TRCreateEventConfirmationViewController.checkPointPickerimageTapped))
        self.checkpointPickerView?.imageView?.userInteractionEnabled = true
        self.checkpointPickerView?.imageView?.addGestureRecognizer(checkPointPickerGestureRecognizer)

        //Add Target to Done Button
        //self.checkpointPickerView?.doneButton.addTarget(self, action: "checkPointPickerimageTapped", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(self.checkpointPickerView)
    }
    
    func addButtons () {
        var labelSting = (self.selectedActivity?.activitySubType!)!
        if let hasDifficulty = self.selectedActivity?.activityDificulty {
            if hasDifficulty != "" {
                labelSting = labelSting + " - " + hasDifficulty
            }
        }
        
        if let light = self.selectedActivity?.activityLight?.integerValue where light > 0 {
            labelSting = labelSting + " " + (self.selectedActivity!.activityLight?.stringValue)! + " Light"
        }
        
        self.buttonOne?.setTitle(labelSting, forState: .Normal)
        self.buttonTwo?.setTitle("Checkpoint - " + (self.selectedActivity?.activityCheckPoint!)!, forState: .Normal)
        self.buttonThress?.setTitle("Start Time - Now", forState: .Normal)
        
        self.addCosmeticsToButtons(self.buttonOne!)
        self.addCosmeticsToButtons(self.buttonTwo!)
        self.addCosmeticsToButtons(self.buttonThress!)
    }

    
    func addCosmeticsToButtons (sender: UIButton) {
        sender.layer.cornerRadius = 3
        sender.layer.masksToBounds = true
        
        sender.layer.shadowOffset = CGSizeMake(0, 1)
        sender.layer.shadowColor = UIColor.blackColor().CGColor
        sender.layer.shadowRadius = 3.0
        sender.layer.shadowOpacity = 0.7
        sender.clipsToBounds = false
        
        let shadowFrame: CGRect = (sender.layer.bounds)
        let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
        sender.layer.shadowPath = shadowPath
    }
    
    //MARK:- UI-ACTIONS
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
        
        let _ = TRCreateEventRequest().createAnEventWithActivity(self.selectedActivity!, selectedTime: self.selectedDate) { (value) -> () in
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
        self.selectedDate = sender.date
    }
    
    // Tapping on Date Picker Image Background will close the date-picker view
    func datePickerimageTapped(sender: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.datePickerView?.alpha = 0
            self.datePickerBackgroundImage?.alpha = 0
        }
        
        if let selectedTime = self.selectedDate {
            self.buttonThress?.setTitle("Start Time - " + selectedTime.toString(), forState: .Normal)
        } else {
            self.buttonThress?.setTitle("Start Time - Now", forState: .Normal)
        }
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

                // Update Label
                // Add Event Title
                self.eventTitleLabel?.text = self.selectedActivity?.activityType
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