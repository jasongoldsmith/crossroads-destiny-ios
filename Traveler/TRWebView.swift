//
//  TRWebView.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRWebView: UIView {
    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
     
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
}
