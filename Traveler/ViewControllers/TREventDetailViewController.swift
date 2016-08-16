//
//  TREventDetailViewController.swift
//  Traveler
//
//  Created by Ashutosh on 8/16/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TREventDetailViewController: TRBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private let EVENT_DESCRIPTION_CELL = "eventDescriptionCell"
    private let EVENT_MESSAGE_CELL = "eventMessageCell"
    
    //Cell Height
    private let event_description_row_height: CGFloat = 54
    
    //Segment Control
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var segmentOneUnderLine: UIImageView?
    @IBOutlet weak var segmentTwoUnderLine: UIImageView?
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTag: TRInsertLabel!
    @IBOutlet weak var eventTable: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    
    
    //Current Event
    var eventInfo: TREventInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentControl?.removeBorders()
        
        let boldFont = UIFont(name: "Helvetica-Bold", size: 14.0)
        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : boldFont!,
            ]
        
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, forState: .Normal)
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, forState: .Selected)
        
        if let hasImage = self.eventInfo?.eventActivity?.activityIconImage {
            let imageURL = NSURL(string: hasImage)
            self.eventIcon.sd_setImageWithURL(imageURL)
        }
        
        if let hasTag = self.eventInfo?.eventActivity?.activityTag where hasTag != "" {
            self.eventTag.text = hasTag
            self.eventTag.layer.cornerRadius = 2
            self.eventTag.clipsToBounds = true
        } else {
            self.eventTag.hidden = true
        }
        
        self.eventName.text = self.eventInfo?.eventActivity?.activitySubType
        
        self.eventTable?.registerNib(UINib(nibName: "TREventDescriptionCell", bundle: nil), forCellReuseIdentifier: EVENT_DESCRIPTION_CELL)
        self.eventTable?.registerNib(UINib(nibName: "TREventMessageCell", bundle: nil), forCellReuseIdentifier: EVENT_MESSAGE_CELL)
        
        let isCurrentUserInTheEvent = TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(self.eventInfo!)
        if isCurrentUserInTheEvent == true {
            self.joinButton.titleLabel?.text = "LEAVE"
            self.joinButton.titleLabel?.backgroundColor = UIColor(red: 230/255, green: 178/255, blue: 0/255, alpha: 1)
        } else {
            self.joinButton.titleLabel?.text = "JOIN"
            self.joinButton.titleLabel?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    //MARK:- IB_ACTIONS
    @IBAction func dismissButton (sender: UIButton) {
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }
    
    @IBAction func shareButton (sender: UIButton) {
        TRApplicationManager.sharedInstance.branchManager?.createLinkWithBranch(self.eventInfo!, deepLinkType: BRANCH_DEEP_LINKING_END_POINT.EVENT_DETAIL.rawValue, callback: {(url, error) in
            if (error == nil) {
                print(url)
                // Group to Share
                let groupToShare = [url!] as [AnyObject]
                
                let activityViewController = UIActivityViewController(activityItems: groupToShare , applicationActivities: nil)
                self.presentViewController(activityViewController, animated: true, completion: {})
            } else {
                print(String(format: "Branch TestBed: %@", error))
            }
        })
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
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.eventTable?.reloadData()
        }
    }
    
    
    //MARK:- Table View Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            let headerView = UILabel()
            headerView.text = self.eventInfo?.clanName
            headerView.textAlignment = .Center
            headerView.textColor = UIColor.whiteColor()
            headerView.font = UIFont(name:"HelveticaNeue", size: 12)
            headerView.backgroundColor = UIColor.clearColor()
            
            return headerView
        } else {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clearColor()
            
            return headerView
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            if section == 0 {
                return 44.0
            }
        }
        
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if self.segmentControl?.selectedSegmentIndex == 0 {
            return (self.eventInfo?.eventPlayersArray.count)!
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: TREventDescriptionCell?
        
        if segmentControl?.selectedSegmentIndex == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(EVENT_DESCRIPTION_CELL) as? TREventDescriptionCell
            cell?.playerUserName.text = self.eventInfo?.eventPlayersArray[indexPath.section].playerPsnID
            
            if let hasImage = self.eventInfo?.eventPlayersArray[indexPath.section].playerImageUrl {
                let imageURL = NSURL(string: hasImage)
                cell?.playerIcon.sd_setImageWithURL(imageURL)
                cell?.playerIcon.roundRectView (1, borderColor: UIColor.grayColor())
            }
            
            self.eventTable?.rowHeight = event_description_row_height
        } else {
            
        }
    
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    
    deinit {
        
    }
}