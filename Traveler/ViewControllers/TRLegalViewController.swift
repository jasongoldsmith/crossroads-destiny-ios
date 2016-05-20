//
//  TRLegalViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRLegalViewController: TRBaseViewController, TRWebViewProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webLegalWebView = NSBundle.mainBundle().loadNibNamed("TRWebView", owner: self, options: nil)[0] as! TRWebView
        webLegalWebView.frame = self.view.frame
        self.view.addSubview(webLegalWebView)

        //Set Delegate
        webLegalWebView.delegate = self
        
        //Add link to open
        let urlString = NSURL(string: "http://stackoverflow.com/questions/12787914/ios-webview-loading-a-url")
        webLegalWebView.loadUrl(urlString!)
    }
    
    func backButtonPressed(sender: UIButton) {
        self.dismissViewController(true) { (didDismiss) in
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
    }
    
    deinit {
    }
}