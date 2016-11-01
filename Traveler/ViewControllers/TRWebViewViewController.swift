//
//  TRWebViewViewController.swift
//  Traveler
//
//  Created by Ashutosh on 10/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class TRWebViewViewController: TRBaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var consoleLoginEndPoint: String?
    var bungieID: String?
    var bungieCookies: [NSHTTPCookie]? = []
    var alamoFireManager : Alamofire.Manager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavigationBarButtons(true, showCancel: false)
        
        let loginRequest = NSURLRequest(URL: NSURL(string: self.consoleLoginEndPoint!)!)
        self.webView.loadRequest(loginRequest)
        self.webView?.delegate = self
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRWebViewViewController.dismissView), name: K.NOTIFICATION_TYPE.USER_DATA_RECEIVED_CLOSE_WEBVIEW, object: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    
    
    override func navBackButtonPressed(sender: UIBarButtonItem?) {
        
        self.webView.stopLoading()
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.navigationBar.hidden = true
    }
    
    func loadUrl (url: NSURL) {
        self.webView.loadRequest(NSURLRequest.init(URL: url))
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if webView.request?.URL?.host == "www.bungie.net" {
            validateCookies()
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("Error: \(error)")
    }
    
    func dismissView() {
        self.dismissViewController(true, dismissed: { (didDismiss) in
            
        })
    }
    
    func validateCookies() {
        
        TRApplicationManager.sharedInstance.bungieVarificationHelper.shouldShowLoginSceen({ (showLoginScreen, error) in
            if let _ = error {
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : TRSignInErrorViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SIGNIN_ERROR) as! TRSignInErrorViewController
                vc.signInError = error
                
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            if showLoginScreen == false {
                self.dismissView()
            }
            }, clearBackGroundRequest: false)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        print("DEINIT - TRWebViewViewController")
    }
}