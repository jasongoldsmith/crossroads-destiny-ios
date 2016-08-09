//
//  TRCreateEventFinalView.swift
//  Traveler
//
//  Created by Ashutosh on 8/8/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRCreateEventFinalView: TRBaseViewController {
    
    
    @IBOutlet weak var activityBGImageView: UIImageView!
    @IBOutlet weak var activityIconView: UIImageView!
    
    //Activities of same sub-typeJ
    lazy var activityInfo: [TRActivityInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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