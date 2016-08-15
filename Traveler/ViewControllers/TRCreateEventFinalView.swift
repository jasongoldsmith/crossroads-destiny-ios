//
//  TRCreateEventFinalView.swift
//  Traveler
//
//  Created by Ashutosh on 8/8/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift

class TRCreateEventFinalView: TRBaseViewController, TRDatePickerProtocol, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var activityBGImageView: UIImageView!
    @IBOutlet weak var activityIconView: UIImageView!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityLevelLabel: UILabel!
    @IBOutlet weak var eventTagLabel: UILabel!
    
    // SubViews
    @IBOutlet weak var activitNameView: UIView!
    @IBOutlet weak var activitCheckPointView: UIView!
    @IBOutlet weak var activitStartTimeView: UIView!
    @IBOutlet weak var activitDetailsView: UIView!
    @IBOutlet weak var activityNameViewsIcon: UIImageView!
    
    // View Button
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activityNameButton: UIButton!
    @IBOutlet weak var activityCheckPointButton: UIButton!
    @IBOutlet weak var activityStartTimeButton: UIButton!
    @IBOutlet weak var activityDetailButton: UIButton!
    @IBOutlet weak var addActivityButton: UIButton!
    
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

    // Filtered Tags
    var filteredTags: [TRActivityInfo] = []
    
    var showGropName: Bool = false
    var showCheckPoint: Bool = false
    var showDetail: Bool = false
    
    //Modifier View
    var modifierView: TRBorderLabelViewContainer?
    
    //Table View
    @IBOutlet weak var dropDownTableView: UITableView!
    var dataArray: [TRActivityInfo] = []
    
    //Date Picker
    var datePickerView: TRDatePicker?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

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
        
        
        //Filtered Arrays
        self.filteredActivitiesOfSubTypeAndDifficulty = self.getFiletreObjOfSubTypeAndDifficulty()!

        //DropDownTable
        self.dropDownTableView.hidden = true
        self.dropDownTableView.layer.borderWidth = 3.0
        self.dropDownTableView.layer.cornerRadius = 2.0
        self.dropDownTableView.layer.borderColor = UIColor(red: 3/255, green: 81/255, blue: 102/255, alpha: 1).CGColor
        
        self.activityDetailButton.setTitle("None", forState: .Normal)
        
        // Update View
        if let _ = self.selectedActivity {
            self.updateViewWithActivity(self.selectedActivity!)
        } else {
            if let _ = self.filteredActivitiesOfSubTypeAndDifficulty.first {
                self.updateViewWithActivity(self.filteredActivitiesOfSubTypeAndDifficulty.first!)
            }
        }
    }
    
    //MARK: - Refresh View
    func updateViewWithActivity (activityInfo: TRActivityInfo) {
        
        //Set Selected Activity
        self.selectedActivity = activityInfo
        
        // Update default selected activity
        if let bonusName = activityInfo.activityBonus.first?.aBonusName {
            self.eventTagLabel.text = bonusName
        } else {
            //Show Modifier
            if let modifier = activityInfo.activityModifiers.first?.aModifierName {
                self.eventTagLabel.text = modifier
            }
        }
        
        // Tag Label
        self.eventTagLabel.text = activityInfo.activityTag
        
        // Update View
        if let activitySubType = activityInfo.activitySubType {
            self.activityNameLabel.text = activitySubType
        }
        
        if let level = activityInfo.activityLevel where level != "0" {
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
            self.activityCheckPointHeightConst.constant = 50
            self.activityCheckPointTopConst.constant = 10
        } else {
            self.activityCheckPointHeightConst.constant = 0
            self.activityCheckPointTopConst.constant = 0
        }
        
        self.filteredTags = self.getActivitiesFilteredSubDifficultyCheckPoint(self.selectedActivity!)!
        for activity in self.filteredTags {
            print("Tags: \(activity.activityTag)")
        }
        
        if let description = activityInfo.activityTag where description != "" {
            self.activityDetailButton.setTitle(description, forState: .Normal)
        } else {
            self.activityDetailButton.setTitle("None", forState: .Normal)
        }
        
        //ModifierView
        self.addModifiersView()
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
    @IBAction func showDatePicker (sender: UIButton) {
        
        guard let _ = self.datePickerView else {
            return
        }
        
        self.datePickerView?.alpha = 0
        UIView.animateWithDuration(0.4) { () -> Void in
            self.datePickerView?.alpha = 1
        }
        
        self.datePickerView?.delegate = self
        self.view.addSubview(self.datePickerView!)
    }
    
    @IBAction func showActivityName (sender: UIButton) {
        
        self.dataArray.removeAll()
        if self.filteredActivitiesOfSubTypeAndDifficulty.count <= 1 {
            return
        }
        
        if self.dropDownTableView?.hidden == false {
            self.dropDownTableView?.hidden = true
            self.showGropName = false
            
            return
        }
        
        self.showGropName = true
        self.dataArray = self.filteredActivitiesOfSubTypeAndDifficulty
        self.dropDownTableView?.hidden = false
        self.dropDownTableView?.reloadData()
        self.updateTableViewFrame(self.activitNameView)
    }
    
    
    @IBAction func showCheckPoints (sender: UIButton) {
        
        self.dataArray.removeAll()
        self.filteredCheckPoints = TRApplicationManager.sharedInstance.getActivitiesMatchingSubTypeAndLevel(self.selectedActivity!)!

        if self.filteredCheckPoints.count <= 1 {
            return
        }
        
        if self.dropDownTableView?.hidden == false {
            self.dropDownTableView?.hidden = true
            self.showCheckPoint = false
            
            return
        }
        
        self.showCheckPoint = true
        self.dataArray = self.filteredCheckPoints
        self.dropDownTableView?.hidden = false
        self.dropDownTableView?.reloadData()
        self.updateTableViewFrame(self.activitCheckPointView)
    }
    
    @IBAction func showDetail (sender: UIButton) {
        self.dataArray.removeAll()
        self.filteredTags = self.getActivitiesFilteredSubDifficultyCheckPoint(self.selectedActivity!)!
        
        if self.filteredTags.count <= 1 {
            return
        }
        
        if self.dropDownTableView?.hidden == false {
            self.dropDownTableView?.hidden = true
            self.showDetail = false
            
            return
        }
        
        self.showDetail = true
        self.dataArray = self.filteredTags
        self.dropDownTableView?.hidden = false
        self.dropDownTableView?.reloadData()
        self.updateTableViewFrame(self.activitDetailsView)
    }
    
    @IBAction func addActivityButtonClicked (sender: UIButton) {
        guard let _ = self.selectedActivity else {
            return
        }
        
        let _ = TRCreateEventRequest().createAnEventWithActivity(self.selectedActivity!, selectedTime: self.datePickerView?.datePicker.date) { (event) -> () in
            
            self.datePickerView?.delegate = nil
            
            if let eventInfo = event {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    self.didMoveToParentViewController(nil)
                    self.removeFromParentViewController()
                    
                    if let eventListViewController = TRApplicationManager.sharedInstance.slideMenuController.mainViewController as? TREventListViewController {
                        eventListViewController.showEventInfoViewController(eventInfo, fromPushNoti: false)
                    }
                })

            } else {
                self.appManager.log.debug("Create Event Failed")
            }
        }
    }
    
    @IBAction func cancelButtonPressed (sender: UIButton) {
        self.datePickerView?.delegate = nil
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }

    @IBAction func backButtonPressed (sender: UIButton) {
        self.datePickerView?.delegate = nil
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
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
    
    //MARK:- Table Delegate Methods
    func updateTableViewFrame (sender: UIView) {
    
        var originY: CGFloat = 0.0
        var maxHeight: CGFloat = 0.0
        
        if sender.frame.origin.y > 450 {
            maxHeight = self.view.frame.size.height + sender.frame.origin.y
        } else {
            maxHeight = self.view.frame.size.height - sender.frame.origin.y + sender.frame.size.height - self.addActivityButton.frame.size.height - 100
        }
        
        var height = CGFloat((self.dropDownTableView?.numberOfSections)! * 47)
        height = height > maxHeight ? maxHeight : height
        
        if sender.frame.origin.y > 450 {
            originY = sender.frame.origin.y - height + 2
        } else {
            originY = sender.frame.origin.y + sender.frame.size.height - 2
        }
        
  
        self.dropDownTableView.frame = CGRectMake(sender.frame.origin.x, originY, sender.frame.size.width,  height)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dropDownCell")
        let activityInfo = self.dataArray[indexPath.section]
       
        if self.showGropName == true {
            if let aType = activityInfo.activityType {
                var nameString = aType
                
                if let aSubType =  activityInfo.activitySubType where aSubType != "" {
                    nameString = "\(aSubType)"
                }
                if let aDifficulty = activityInfo.activityDificulty where aDifficulty != "" {
                    nameString = "\(nameString) - \(aDifficulty)"
                }
                
                cell!.textLabel!.text = nameString
            }
        } else if self.showCheckPoint == true {
            cell!.textLabel!.text = activityInfo.activityCheckPoint!
        } else {
            cell!.textLabel!.text = activityInfo.activityTag!
            if activityInfo.activityTag! == "" {
                cell!.textLabel!.text = "None"
            }
        }
        
        return cell!
    }
    
    func closeDropDown () {
        self.dropDownTableView.hidden = true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section < self.dataArray.count {
            
            self.showCheckPoint = self.showCheckPoint == true ? false : false
            self.showGropName = self.showGropName == true ? false : false
            self.showDetail = self.showDetail == true ? false : false
            
            self.updateViewWithActivity(self.dataArray[indexPath.section])
            self.closeDropDown()
        }
    }
    
    func getActivitiesFilteredSubDifficultyCheckPoint (activity: TRActivityInfo) -> [TRActivityInfo]? {
        let activityArray = self.activityInfo.filter {$0.activitySubType == activity.activitySubType && $0.activityDificulty == activity.activityDificulty && $0.activityCheckPoint == activity.activityCheckPoint
        }
        return activityArray
    }
    
    //MARK:- Bounded Box Labels
    func addModifiersView () {
        
        var mofifiersArray: [String] = []
        if self.selectedActivity?.activityModifiers.count > 0 {
            for modifiers in (self.selectedActivity?.activityModifiers)! {
                mofifiersArray.append(modifiers.aModifierName!)
            }
        } else {
            if let hasCheckPoint = self.selectedActivity?.activityCheckPoint where hasCheckPoint != ""{
                mofifiersArray.append(hasCheckPoint)
            }
        }

        if mofifiersArray.count == 0 {
            return
        }
        
        self.modifierView?.removeFromSuperview()
        
        self.modifierView = NSBundle.mainBundle().loadNibNamed("TRBorderLabelViewContainer", owner: self, options: nil)[0] as? TRBorderLabelViewContainer
        self.view.addSubview(self.modifierView!)
        
        if self.selectedActivity?.activityBonus.count > 0 {
            for bonus in (self.selectedActivity?.activityBonus)! {
                mofifiersArray.append(bonus.aBonusName!)
            }
        }
       
        self.modifierView?.updateViewWithStringArray(mofifiersArray)
        var labelWidth: CGFloat?
        
        switch mofifiersArray.count {
        case 1:
            labelWidth = self.modifierView?.labelOne?.intrinsicContentSize().width
            break
        case 2:
            labelWidth = (self.modifierView?.labelOne?.intrinsicContentSize().width)! + (self.modifierView?.labelTwo?.intrinsicContentSize().width)!
            break
        case 3:
            break
        case 4:
            break
        case 5:
            break
        default:
            break
        }

        self.modifierView?.frame = CGRectMake(self.activitNameView.frame.origin.x, self.eventTagLabel.frame.origin.y + self.eventTagLabel.frame.size.height + 25 , labelWidth!, 40)

        self.modifierView!.center = CGPointMake(self.view.center.x, (self.modifierView?.frame.origin.y)!)
     }
    
    deinit {
        
    }
}