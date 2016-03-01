//
//  TREventListViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

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
        let boldTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : boldFont!,
        ]
        self.segmentControl!.setTitleTextAttributes(boldTextAttributes, forState: .Normal)
        self.segmentControl!.setTitleTextAttributes(boldTextAttributes, forState: .Selected)
        
    
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.eventsInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CURRENT_EVENT_CELL) as! TREventTableCellView
        cell.updateCellViewWithEvent(eventsInfo[indexPath.section])
        cell.joinEventButton?.addTarget(self, action: "joinAnEvent:", forControlEvents: .TouchUpInside)
        cell.joinEventButton?.buttonEventInfo = eventsInfo[indexPath.section]
        
        //Event Creator
        let eventCreator = eventsInfo[indexPath.section].eventCreator
        appManager.log.debug("Event Creator: \(eventCreator?.playerUserName)")
        
        
//        // SDWebImage Usage
//        let url = NSURL(string: "https://pbs.twimg.com/profile_images/447374371917922304/P4BzupWu.jpeg")
//        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//            print("Image: \(image)")
//        }
//        cell.eventIcon?.sd_setImageWithURL(url, completed: block)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func joinAnEvent (sender: JoinEventButton) {
        print("Senders Event: \(sender.buttonEventInfo?.eventID!)")
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
