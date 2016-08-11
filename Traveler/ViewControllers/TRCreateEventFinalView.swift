//
//  TRCreateEventFinalView.swift
//  Traveler
//
//  Created by Ashutosh on 8/8/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRCreateEventFinalView: TRBaseViewController, TRDatePickerProtocol, DropDownTableProtocol {
    
    
    @IBOutlet weak var activityBGImageView: UIImageView!
    @IBOutlet weak var activityIconView: UIImageView!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityLevelLabel: UILabel!
    
    // SubViews
    @IBOutlet weak var activitNameView: UIView!
    @IBOutlet weak var activitCheckPointView: UIView!
    @IBOutlet weak var activitStartTimeView: UIView!
    @IBOutlet weak var activitDetailsView: UIView!
    @IBOutlet weak var activityNameViewsIcon: UIImageView!
    
    // View Button
    @IBOutlet weak var activityNameButton: UIButton!
    @IBOutlet weak var activityCheckPointButton: UIButton!
    @IBOutlet weak var activityStartTimeButton: UIButton!
    @IBOutlet weak var activityDetailButton: UIButton!
    
    //Constaint outlets
    @IBOutlet weak var activityCheckPointHeightConst: NSLayoutConstraint!
    @IBOutlet weak var activityCheckPointTopConst: NSLayoutConstraint!
    
    //Activities of same sub-typeJ
    var selectedActivity: TRActivityInfo?
    lazy var activityInfo: [TRActivityInfo] = []
    
    // Contains Unique Activities Based on SubType/ Difficulty
    var filteredActivitiesOfSubTypeAndDifficulty: [TRActivityInfo] = []

    // Contains Unique Activities Based on SubType/ Difficulty
    var filteredCheckPoints: [TRActivityInfo] = []

    //Date Picker
    var datePickerView: TRDatePicker?
    
    //CheckPoint
    lazy var actcheckPointsArr: [String] = []
    
    //Similar Activities
    lazy var actOfSameTypeArr : [TRActivityInfo] = []
    
    //TableView
    var dropTableView: TRDropDownTableView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    //Button States
    var isActivityNameButtonOpen: Bool = false
    var isActivityCheckPointButtonOpen: Bool = false
    var isActivityDetailsButtonOpen: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Adding Corner Radius to Views
        self.activitNameView.layer.cornerRadius = 2.0
        self.activitDetailsView.layer.cornerRadius = 2.0
        self.activitStartTimeView.layer.cornerRadius = 2.0
        self.activitCheckPointView.layer.cornerRadius = 2.0
        
        //Add Date Picker
        self.datePickerView = NSBundle.mainBundle().loadNibNamed("TRDatePicker", owner: self, options: nil)[0] as? TRDatePicker
        self.datePickerView?.frame = self.view.bounds
        self.datePickerView?.delegate = self
    
        
        //DropDown Table
        self.dropTableView = NSBundle.mainBundle().loadNibNamed("TRDropDownTableView", owner: self, options: nil)[0] as? TRDropDownTableView
        self.dropTableView?.delegate = self
        self.dropTableView?.hidden = true
        self.view.addSubview(self.dropTableView!)
        
        //Filtered Arrays
        self.filteredActivitiesOfSubTypeAndDifficulty = self.getFiletreObjOfSubTypeAndDifficulty()!
        
        //Get similar activities with different CheckPoints
        self.filteredCheckPoints = TRApplicationManager.sharedInstance.getActivitiesMatchingSubTypeAndLevel(self.filteredActivitiesOfSubTypeAndDifficulty.first!)!

        // Update View
        if let _ = self.filteredActivitiesOfSubTypeAndDifficulty.first {
            self.updateViewWithActivity(self.filteredActivitiesOfSubTypeAndDifficulty.first!)
        }
    }
    
    //MARK: - Refresh View
    func updateViewWithActivity (activityInfo: TRActivityInfo) {
        
        // Update default selected activity
        self.selectedActivity = activityInfo
        
        // Update View
        if let activitySubType = activityInfo.activitySubType {
            self.activityNameLabel.text = activitySubType
        }
        
        if let level = activityInfo.activityLevel where Int(level) > 0 {
            let activityLavelString: String = "LEVEL \(level) "
            let stringFontAttribute = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 12)!]
            let levelAttributedStr = NSAttributedString(string: activityLavelString, attributes: stringFontAttribute)
            let finalString: NSMutableAttributedString = levelAttributedStr.mutableCopy() as! NSMutableAttributedString
            
            if let activityLight = activityInfo.activityLight  where Int(activityLight) > 0 {
                let activityAttrString = NSMutableAttributedString(string: "Recommended Light: ")
                let activityColorString = NSMutableAttributedString(string: "\u{02726} \(activityLight)")
                activityColorString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1) , range: NSMakeRange(0, activityColorString.length))
                
                activityAttrString.appendAttributedString(activityColorString)
                finalString.appendAttributedString(activityAttrString)
            }
            
            self.activityLevelLabel.attributedText = finalString
            
            if let _ = activityInfo.activityIconImage {
                let imageUrl = NSURL(string: activityInfo.activityIconImage!)
                self.activityIconView.sd_setImageWithURL(imageUrl)
            }
        }
        
        if let _ = activityInfo.activityImage {
            let imageURL = NSURL(string: activityInfo.activityImage!)
            self.activityBGImageView.sd_setImageWithURL(imageURL)
        }
        
        if let _ = activityInfo.activityIconImage {
            let imageURL = NSURL(string: activityInfo.activityIconImage!)
            self.activityNameViewsIcon.sd_setImageWithURL(imageURL)
        }
        
        if let aType = activityInfo.activityType {
            var nameString = aType
            
            if let aSubType =  activityInfo.activitySubType where aSubType != "" {
                nameString = "\(nameString) - \(aSubType)"
            }
            if let aDifficulty = activityInfo.activityDificulty where aDifficulty != "" {
                nameString = "\(nameString) - \(aDifficulty)"
            }
            
            self.activityNameButton.setTitle(nameString, forState: .Normal)
        }
        
        if let aCheckPoint = activityInfo.activityCheckPoint where aCheckPoint != "" {
            self.activityCheckPointButton.setTitle(aCheckPoint, forState: .Normal)
        } else {
            self.activityCheckPointHeightConst.constant = 0
            self.activityCheckPointTopConst.constant = 0
        }
    }
    
    //MARK: - Protocol Methods
    func closeDatePicker() {
        if let selectedTime = self.datePickerView?.datePicker.date {
            self.activityStartTimeButton?.setTitle("Start Time - " + selectedTime.toString(format: .Custom(trDateFormat())), forState: .Normal)
        } else {
            self.activityStartTimeButton?.setTitle("Start Time - Now", forState: .Normal)
        }
    }
    
    //MARK: - Button Actions
    @IBAction func activityNameButtonClicked (sender: UIButton) {
        
        if self.filteredActivitiesOfSubTypeAndDifficulty.count <= 1 {
            return
        }
        
        if self.dropTableView?.hidden == false {
            self.closeDropDownTable()
            self.dropTableView?.dataArray.removeAll()
            self.isActivityNameButtonOpen = false
            
            return
        }
        
        for activityInfo in self.filteredActivitiesOfSubTypeAndDifficulty {
            
            if let aType = activityInfo.activityType {
                var nameString = aType
                
                if let aSubType =  activityInfo.activitySubType where aSubType != "" {
                    nameString = "\(nameString) - \(aSubType)"
                }
                if let aDifficulty = activityInfo.activityDificulty where aDifficulty != "" {
                    nameString = "\(nameString) - \(aDifficulty)"
                }
                
                self.dropTableView?.dataArray.append(nameString)
            }
        }
        
        self.dropTableView?.hidden = false
        self.isActivityNameButtonOpen = true
        self.addTableViewWithParent(self.activitNameView)
    }
    
    @IBAction func showDatePicker (sender: UIButton) {
        
        guard let _ = self.datePickerView else {
            return
        }
        
        self.datePickerView?.alpha = 0
        self.view.addSubview(self.datePickerView!)
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.datePickerView?.alpha = 1
        }
    }
    
    @IBAction func showCheckPoints (sender: UIButton) {
        
        if self.filteredCheckPoints.count <= 1 {
            return
        }
        
        if self.dropTableView?.hidden == false {
            self.closeDropDownTable()
            self.dropTableView?.dataArray.removeAll()
            self.isActivityCheckPointButtonOpen = false
            
            return
        }
        
        for activity in self.filteredCheckPoints {
            self.dropTableView?.dataArray.append(activity.activityCheckPoint!)
        }
        
        self.dropTableView?.hidden = false
        self.isActivityCheckPointButtonOpen = true
        self.addTableViewWithParent(self.activitCheckPointView)
    }
    
    @IBAction func showDetail (sender: UIButton) {
        
        if self.dropTableView?.hidden == false {
            self.closeDropDownTable()
            self.isActivityDetailsButtonOpen = false
            
            return
        }

        self.dropTableView?.hidden = false
        self.isActivityDetailsButtonOpen = true
        self.addTableViewWithParent(self.activitDetailsView)
    }
    
    @IBAction func addActivityButtonClicked (sender: UIButton) {
        guard let _ = self.selectedActivity else {
            return
        }
        
        guard let activityDate = self.datePickerView?.datePicker?.date else {
            return
        }

        
        let _ = TRCreateEventRequest().createAnEventWithActivity(self.selectedActivity!, selectedTime: activityDate) { (value) -> () in
            if (value == true) {

                self.datePickerView?.delegate = nil
                self.datePickerView?.removeFromSuperview()

                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    self.didMoveToParentViewController(nil)
                    self.removeFromParentViewController()
                })
            } else {
                self.appManager.log.debug("Create Event Failed")
            }
        }
    }
    
    @IBAction func cancelButtonPressed (sender: UIButton) {
        
        self.datePickerView?.delegate = nil
        self.datePickerView?.removeFromSuperview()

        self.dropTableView?.delegate = nil
        self.dropTableView?.removeFromSuperview()

        self.dismissViewController(true) { (didDismiss) in
            
        }
    }

    @IBAction func backButtonPressed (sender: UIButton) {
        
        self.datePickerView?.delegate = nil
        self.datePickerView?.removeFromSuperview()
        
        self.dropTableView?.delegate = nil
        self.dropTableView?.removeFromSuperview()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK:- Table View Methods
    func addTableViewWithParent (sender: UIView) {
        
        let height = CGFloat((self.dropTableView?.dropDownTable.numberOfSections)! * 47)
        self.dropTableView?.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + sender.frame.size.height - (self.dropTableView?.layer.cornerRadius)!, sender.frame.width, height)
        
        //self.dropTableView?.addDropDownAnimation()
    }
    
    func didSelectRowAtIndex(index: Int) {
        
        var dataArray: [TRActivityInfo] = []
        switch true {
        case self.isActivityNameButtonOpen:
            dataArray = self.filteredActivitiesOfSubTypeAndDifficulty
            self.isActivityNameButtonOpen = false
            break
        case self.isActivityCheckPointButtonOpen:
            dataArray = self.filteredCheckPoints
            self.isActivityCheckPointButtonOpen = false
            break
        case self.isActivityDetailsButtonOpen:
            break
        default:
            break
        }
        
        if index < dataArray.count {
            let activitySelected = dataArray[index]
            
            self.selectedActivity = activitySelected
            self.updateViewWithActivity(self.selectedActivity!)
            
            self.dropTableView?.dataArray.removeAll()
            self.closeDropDownTable()
        }
    }
    
    func closeDropDownTable () {
        self.dropTableView?.hidden = true
    }
    
    
    //MARK:- Array Filtering
    //MARK:- DATA METHODS
    func getFiletreObjOfSubTypeAndDifficulty () -> [TRActivityInfo]? {
        
        var filteredArray: [TRActivityInfo] = []
        for (_, activity) in self.activityInfo.enumerate() {
            if (self.activityInfo.count < 1) {
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
        
    }
}