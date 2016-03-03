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
    @IBOutlet var segmentOneUnderLine: UIImageView?
    @IBOutlet var segmentTwoUnderLine: UIImageView?
    @IBOutlet var currentPlayerAvatorIcon: UIImageView?
    
    //Events Information
    let eventsInfo = TRApplicationManager.sharedInstance.eventsList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentControl?.removeBorders()
      
        let boldFont = UIFont(name: "Helvetica-Bold", size: 16.0)
        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : boldFont!,
        ]
        
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, forState: .Normal)
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, forState: .Selected)
        
    
        self.eventsTableView?.registerNib(UINib(nibName: "TREventTableCellView", bundle: nil), forCellReuseIdentifier: CURRENT_EVENT_CELL)
        self.eventsTableView?.tableFooterView = UIView(frame: CGRectZero)
        
        //Adding Radius to the Current Player Avator
        self.currentPlayerAvatorIcon?.layer.cornerRadius = (self.currentPlayerAvatorIcon?.frame.width)!/2
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        
        return 10.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.eventsInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CURRENT_EVENT_CELL) as! TREventTableCellView
        
        if segmentControl?.selectedSegmentIndex == 0 {
            cell.updateCellViewWithEvent(eventsInfo[indexPath.section])
            cell.joinEventButton?.addTarget(self, action: "joinAnEvent:", forControlEvents: .TouchUpInside)
            cell.joinEventButton?.buttonEventInfo = eventsInfo[indexPath.section]
        } else {
            cell.updateCellViewWithEvent(eventsInfo[4])
            cell.joinEventButton?.addTarget(self, action: "joinAnEvent:", forControlEvents: .TouchUpInside)
            cell.joinEventButton?.buttonEventInfo = eventsInfo[indexPath.section]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.eventsTableView?.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func joinAnEvent (sender: JoinEventButton) {
      
        if let eventInfo = sender.buttonEventInfo {
            _ = TRJoinEventRequest().joinEventWithUserForEvent(TRUserInfo.getUserID()!, eventInfo: eventInfo, completion: { (value) -> () in
                if (value == true) {
                    self.reloadEventTable()
                } else {
                    print("Failed")
                }
            })
        }
    }
    
    func reloadEventTable () {
        self.eventsTableView?.reloadData()
    }
    
    @IBAction func segmentControlSelection (sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.segmentOneUnderLine?.hidden = false
            self.segmentTwoUnderLine?.hidden = true
            break;
        case 1:
            self.segmentOneUnderLine?.hidden = true
            self.segmentTwoUnderLine?.hidden = false
            break;
        default:
            break;
        }
        
        //Reload Data
        self.reloadEventTable()
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
