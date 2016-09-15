//
//  TRLoginOptionViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import iCarousel

class TRLoginOptionViewController: TRBaseViewController, iCarouselDataSource, iCarouselDelegate {
    
    
    var items: [TREventInfo] = TRApplicationManager.sharedInstance.eventsList
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var carousel : iCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countString = TRApplicationManager.sharedInstance.totalUsers?.description
        let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)]
        var countAttributedStr = NSAttributedString(string: countString!, attributes: stringColorAttribute)
        let helpAttributedStr = NSAttributedString(string: " Guardians looking for your help:", attributes: nil)
        
        if TRApplicationManager.sharedInstance.totalUsers < 1 {
            countAttributedStr = NSAttributedString(string: "", attributes: nil)
        }

        let finalString:NSMutableAttributedString = countAttributedStr.mutableCopy() as! NSMutableAttributedString
        finalString.appendAttributedString(helpAttributedStr)

        self.playerCountLabel.attributedText = finalString
        self.carousel?.autoscroll = -0.1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func signIntBtnTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("TRSignInView", sender: self)
    }
    
    @IBAction func trUnwindActionToLoginOption(segue: UIStoryboardSegue) {
        
    }
    
    //MARK:- carousel
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return items.count
    }

    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
       
        var itemView: TRCaroselCellView
        
        //create new view if no view is available for recycling
        if (view == nil) {
            itemView = NSBundle.mainBundle().loadNibNamed("TRCaroselCellView", owner: self, options: nil)[0] as! TRCaroselCellView
        } else {
            itemView = view as! TRCaroselCellView
        }
        
        itemView.updateViewWithActivity(items[index])
        return itemView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch (option)
        {
        case .Wrap:
            return 1
        case .Spacing:
            return value * 1.04
        case .VisibleItems:
            return 3
        default:
            return value
        }
    }
}
