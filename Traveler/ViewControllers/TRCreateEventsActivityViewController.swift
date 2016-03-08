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
    
    @IBOutlet var pickerOne: UIPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ADD NAVIGATION BAR BUTTON
        addNavigationBarButtons()
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

    func backButtonPressed (sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    //#MARK:- PICKER_VIEW
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "hello"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    deinit {
        appManager.log.debug("")
    }
}

