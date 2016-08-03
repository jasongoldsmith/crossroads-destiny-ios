//
//  TRErrorView.swift
//  Traveler
//
//  Created by Ashutosh on 7/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

@objc protocol ErrorViewProtocol {
    optional func addActivity ()
    optional func addConsole ()
    optional func goToBungie ()
}

class TRErrorView: UIView {
    
    var errorType: Branch_Error?
    var delegate: ErrorViewProtocol?
    var eventInfo: TREventInfo?
    
    @IBOutlet weak var buttonOneYes: UIButton!
    @IBOutlet weak var buttonTwoCancel: UIButton!
    @IBOutlet weak var errorDescription: UILabel!
    
    @IBAction func closeErrorView () {
        self.delegate = nil
        self.removeFromSuperview()
    }
    
    @IBAction func buttonOneYesPressed (sender: UIButton) {
        switch self.errorType! {
        case .ACTIVITY_NOT_AVAILABLE:
            self.delegate?.addActivity!()
            break
        case .MAXIMUM_PLAYERS_REACHED:
            self.delegate?.addActivity!()
            break
        case .NEEDS_CONSOLE:
            self.delegate?.addConsole!()
            break
        case .JOIN_BUNGIE_GROUP:
            self.delegate?.goToBungie!()
            break
        }
        
        self.delegate = nil
        self.removeFromSuperview()
    }
    
    @IBAction func buttonTwoCancelPressed (sender: UIButton) {
        self.closeErrorView()
    }

    override func layoutSubviews() {
        
        //Button radius
        self.buttonOneYes.layer.cornerRadius = 2.0
        
        switch self.errorType! {
        case .ACTIVITY_NOT_AVAILABLE:
            self.buttonOneYes.setTitle("ADD THIS ACTIVITY", forState: .Normal)
            self.errorDescription.text = "Sorry, that \(self.eventInfo?.eventActivity?.activitySubType) is no longer available. Would you like to add one of your own?"
            break
        case .MAXIMUM_PLAYERS_REACHED:
            self.buttonOneYes.setTitle("YES", forState: .Normal)
            self.errorDescription.text = "The maximum amount of players has been reached for this activity. Would you like to add one of your own?"
            break
        case .NEEDS_CONSOLE:
            let console = self.eventInfo?.eventCreator?.playerConsoles.first?.consoleType
            self.buttonOneYes.setTitle("ADD MY \(console)", forState: .Normal)
            self.errorDescription.text = "You’ll need to be on \(console) to join that activity from <group>. Add another console to your account?"
            break
        case .JOIN_BUNGIE_GROUP:
            self.buttonOneYes.setTitle("VIEW GROUP ON BUNGIE.NET", forState: .Normal)
            self.errorDescription.text = "You’ll need to be in the <group> to join \(self.eventInfo?.eventActivity?.activitySubType). Request to join?"
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