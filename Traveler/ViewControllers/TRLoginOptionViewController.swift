//
//  TRLoginOptionViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import iCarousel
import TTTAttributedLabel


class TRLoginOptionViewController: TRBaseViewController, iCarouselDataSource, iCarouselDelegate, TTTAttributedLabelDelegate {
    
    
    var items: [TREventInfo] = TRApplicationManager.sharedInstance.eventsList
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var carousel : iCarousel!
    @IBOutlet weak var legalLabel: TTTAttributedLabel!
    
    
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
        
        //Legal Statement
        self.addLegalStatmentText()
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
    
    func addLegalStatmentText () {
        let legalString = "By clicking the \"Next\" button below, I have read and agree to the Crossroads Terms of Service and Privacy Policy."
        
        let customerAgreement = "Terms of Service"
        let privacyPolicy = "Privacy Policy"
        
        self.legalLabel?.text = legalString
        
        // Add HyperLink to Bungie
        let nsString = legalString as NSString
        
        let rangeCustomerAgreement = nsString.rangeOfString(customerAgreement)
        let rangePrivacyPolicy = nsString.rangeOfString(privacyPolicy)
        let urlCustomerAgreement = NSURL(string: "https://www.crossroadsapp.co/terms")!
        let urlPrivacyPolicy = NSURL(string: "https://www.crossroadsapp.co/privacy")!
        
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        self.legalLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.legalLabel?.addLinkToURL(urlCustomerAgreement, withRange: rangeCustomerAgreement)
        self.legalLabel?.addLinkToURL(urlPrivacyPolicy, withRange: rangePrivacyPolicy)
        self.legalLabel?.delegate = self
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
        legalViewController.linkToOpen = url
        self.presentViewController(legalViewController, animated: true, completion: {
            
        })
    }
}
