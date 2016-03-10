//
//  TRCreateEventConfirmationViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/9/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


class TRCreateEventConfirmationViewController: TRBaseViewController {
    
    
    @IBOutlet weak var activityIconImage: UIImageView?
    @IBOutlet weak var buttonOne: UIButton?
    @IBOutlet weak var buttonTwo: UIButton?
    @IBOutlet weak var buttonThress: UIButton?
    @IBOutlet weak var datePickerView: UIDatePicker?
    @IBOutlet weak var datePickerBackgroundImage: UIImageView?
    
    var selectedActivity: TRActivityInfo?
    
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
        
        // Add Tap Gesture to PickerBackGround ImageView
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        self.datePickerBackgroundImage?.userInteractionEnabled = true
        self.datePickerBackgroundImage?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addNavigationBarButtons () {
        
        //Adding Back Button to nav Bar
        let leftButton = UIButton(frame: CGRectMake(0,0,30,30))
        leftButton.setImage(UIImage(named: "iconBackArrow"), forState: .Normal)
        leftButton.addTarget(self, action: Selector("backButtonPressed:"), forControlEvents: .TouchUpInside)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = leftButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.buttonOne?.setTitle(self.selectedActivity?.activitySubType!, forState: .Normal)
        self.buttonTwo?.setTitle("Checkpoint - " + (self.selectedActivity?.activityCheckPoint!)!, forState: .Normal)
        self.buttonThress?.setTitle("Start Time - Now", forState: .Normal)
    }
    
    //MARK:- UI-ACTIONS
    func backButtonPressed (sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func changeDateButtonPressed (sender: UIButton) {
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.datePickerView?.alpha = 1
            self.datePickerBackgroundImage?.alpha = 0.5
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
    func imageTapped(sender: UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.datePickerView?.alpha = 0
            self.datePickerBackgroundImage?.alpha = 0
        }
        
        let choosenDate = self.datePickerView?.date
        self.buttonThress?.setTitle("\(choosenDate!)", forState: .Normal)
    }
    
    deinit {
        appManager.log.debug("")
    }
}