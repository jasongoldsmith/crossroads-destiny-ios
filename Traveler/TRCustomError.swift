//
//  TRCustomError.swift
//  Traveler
//
//  Created by Ashutosh on 9/27/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


@objc protocol CustomErrorDelegate {
    optional func customErrorActionButtonPressed ()
}


class TRCustomError: UIView {
 
    var delegate: CustomErrorDelegate?
    
    @IBOutlet weak var errorViewContainer: UIView!
    @IBOutlet weak var errorMessageHeader: UILabel!
    @IBOutlet weak var errorMessageDescription: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        self.actionButton?.layer.cornerRadius = 2.0
        self.errorViewContainer?.layer.cornerRadius = 2.0
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
    }
    
    
    @IBAction func closeView () {
        
        if let _ = self.delegate {
            self.delegate = nil
        }
        
        self.removeFromSuperview()
    }
    
    @IBAction func actionButtonPressed () {
        self.delegate?.customErrorActionButtonPressed!()
    }
}