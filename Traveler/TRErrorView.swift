//
//  TRErrorView.swift
//  Traveler
//
//  Created by Ashutosh on 7/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRErrorView: UIView {
    
    var errorType: Branch_Error?
    
    @IBOutlet weak var buttonOneYes: UIButton!
    @IBOutlet weak var buttonTwoCancel: UIButton!
    
    
    @IBAction func closeErrorView () {
        self.removeFromSuperview()
    }
    
    @IBAction func buttonOneYesPressed (sender: UIButton) {
        
    }
    
    @IBAction func buttonTwoCancelPressed (sender: UIButton) {
        
    }

    override func layoutSubviews() {
        
        //Button radius
        self.buttonOneYes.layer.cornerRadius = 2.0
        
        let console = "t"
        switch self.errorType! {
        case .ACTIVITY_NOT_AVAILABLE:
            self.buttonOneYes.setTitle("ADD THIS ACTIVITY", forState: .Normal)
            break
        case .MAXIMUM_PLAYERS_REACHED:
            self.buttonOneYes.setTitle("YES", forState: .Normal)
            break
        case .NEEDS_CONSOLE:
            self.buttonOneYes.setTitle("ADD MY \(console)", forState: .Normal)
            break
        case .JOIN_BUNGIE_GROUP:
            self.buttonOneYes.setTitle("VIEW GROUP ON BUNGIE.NET", forState: .Normal)
            break
        }
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
}
