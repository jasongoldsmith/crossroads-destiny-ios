//
//  TRSignInErrorViewController.swift
//  Traveler
//
//  Created by Ashutosh on 9/14/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRSignInErrorViewController: TRBaseViewController {
    
    var userName: String?
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var starOneLabel: UILabel!
    @IBOutlet weak var starTwoLabel: UILabel!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoView?.layer.cornerRadius = 2.0
        self.starOneLabel?.text = "\u{02726}"
        self.starTwoLabel?.text = "\u{02726}"
        
        if let _ = self.userName {
            self.userInfoLabel?.text = "We couldn’t find a Bungie.net profile linked to the \(self.userName!) you entered."
            self.userNameLabel?.text = self.userName! 
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func openContactUs () {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRSendReportViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as! TRSendReportViewController

        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func closeView () {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    deinit {
        
    }
}