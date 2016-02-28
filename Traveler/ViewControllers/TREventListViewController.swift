//
//  TREventListViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import Foundation

private let CURRENT_EVENT_CELL = "currentEventCell"

class TREventListViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var segmentControl: UISegmentedControl?
    @IBOutlet var eventsTableView: UITableView?
    
    //Events Information
    let eventsInfo = TRApplicationManager.sharedInstance.eventsInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentControl?.removeBorders()
      
        let boldFont = UIFont(name: "Helvetica-Bold", size: 16.0)
        let boldTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : boldFont!,
        ]
        self.segmentControl!.setTitleTextAttributes(boldTextAttributes, forState: .Normal)
        self.segmentControl!.setTitleTextAttributes(boldTextAttributes, forState: .Selected)
        
    
        self.eventsTableView?.registerNib(UINib(nibName: "TREventTableCellView", bundle: nil), forCellReuseIdentifier: CURRENT_EVENT_CELL)
        self.eventsTableView?.tableFooterView = UIView(frame: CGRectZero)
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.eventsInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CURRENT_EVENT_CELL) as! TREventTableCellView
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @IBAction func segmentControlSelection (sender: UISegmentedControl) {
        print("\(sender.selectedSegmentIndex)")
    }
    
    
    @IBAction func createNewEvent (sender: UIButton) {
        
    }
    
    deinit {
        self.appManager.log.debug("de-init")
    }
    
    
    /*
    @IBAction func logoutBtnTapped(sender: AnyObject) {
    
    let createRequest = TRAuthenticationRequest()
    createRequest.logoutTRUser() { (value ) in  //, errorData) in
    if value == true {
    
    TRUserInfo.removeUserData()
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    else
    {
    self.displayAlertWithTitle("Logout Failed")
    }
    }
    }
    */
}
