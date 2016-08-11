//
//  TRCreateEventFinalView.swift
//  Traveler
//
//  Created by Ashutosh on 8/8/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRCreateEventFinalView: TRBaseViewController, TRDatePickerProtocol {
    
    
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
        
        
        // Update View
        if let _ = self.activityInfo.first {
            self.updateViewWithActivity(self.activityInfo.first!)
        }
        
        //Add Date Picker
        self.datePickerView = NSBundle.mainBundle().loadNibNamed("TRDatePicker", owner: self, options: nil)[0] as? TRDatePicker
        self.datePickerView?.frame = self.view.bounds
        self.datePickerView?.delegate = self
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
    
    @IBAction func showCheckPoints (sender: UIButton) {
        
    }
    
    @IBAction func showDetail (sender: UIButton) {
        
    }
    
    @IBAction func addActivityButtonClicked (sender: UIButton) {
        guard let _ = self.selectedActivity else {
            return
        }
    }
    
    @IBAction func cancelButtonPressed (sender: UIButton) {
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }

    @IBAction func backButtonPressed (sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    deinit {
        
    }
}