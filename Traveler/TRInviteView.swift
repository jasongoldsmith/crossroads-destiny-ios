//
//  TRInviteView.swift
//  Traveler
//
//  Created by Ashutosh on 10/11/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import pop


class TRInviteView: UIView, KSTokenViewDelegate {
    
    var keys = [String]()
    let names: Array<String> = ["ashu", "singh"]
    
    @IBOutlet var tokenView: KSTokenView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tokenViewContainerBackground:UIImageView!
    
    func setUpView () {
        self.descriptionLabel?.text = "Inviting players will send them \n a message on Bungie.net."
        
        self.tokenView.delegate = self
        self.tokenView.placeholder = "Type to search"
        self.tokenView.maxTokenLimit = 5
        self.tokenView.minimumCharactersToSearch = 100
        self.tokenView.style = .Squared
        self.tokenView.backgroundColor = UIColor(red: CGFloat(32)/CGFloat(255), green: CGFloat(50)/CGFloat(255), blue: CGFloat(54)/CGFloat(255), alpha: 1)
        self.tokenView.searchResultSize = CGSize(width: 0, height: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    internal func tokenView(token: KSTokenView, performSearchWithString string: String, completion: ((results: Array<AnyObject>) -> Void)?) {
        if (string.characters.isEmpty){
            completion!(results: names)
            return
        }
        
        var data: Array<String> = []
        for value: String in names {
            if value.lowercaseString.rangeOfString(string.lowercaseString) != nil {
                data.append(value)
            }
        }
        completion!(results: data)
    }
    
    internal func tokenView(token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
    
    internal func tokenView(tokenView: KSTokenView, shouldAddToken token: KSToken) -> Bool {
        if token.title == "f" {
            return false
        }
        return true
    }
    
    @IBAction func closeInviteView () {
        
        //Remove TokenView
        self.tokenView.removeFromSuperview()
        
        let trans = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
        trans.fromValue = NSValue(CGPoint: CGPointMake(0, 0))
        trans.toValue = NSValue(CGPoint: CGPointMake(0, self.bounds.size.height))
        trans.springSpeed = 2
        self.layer.pop_addAnimation(trans, forKey: "Translation")
        
        let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        popAnimation.toValue = 0.0
        popAnimation.duration = 0.7
        self.pop_addAnimation(popAnimation, forKey: "alphasIn")
        
        trans.completionBlock = {(animation, finished) in
            self.tokenView.delegate = nil
            self.removeFromSuperview()
        }
    }
    
    func tokenViewHeightUpdated(tokenFieldHeight: CGFloat) {
        self.tokenViewContainerBackground.frame = CGRectMake(0, 0, self.tokenViewContainerBackground.frame.size.width, tokenFieldHeight)
    }
}
