//
//  OnBoardingCard.swift
//  Traveler
//
//  Created by Marin, Jonathan on 4/3/17.
//  Copyright © 2017 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON
import SDWebImage

class OnBoardingCard: NSObject {
    var required:Bool = true
    var language:String?
    var order:Int = 0
    var backgroundImage = UIImageView()
    var heroImage = UIImageView()
    var textImage = UIImageView()
    
    func parse(json:JSON) {
        if let backgroundURLString = json["backgroundImageUrl"].string,
            let backgroundURL = NSURL(string: backgroundURLString) {
            backgroundImage.sd_setImageWithURL(backgroundURL)
        }
        if let imageURLString = json["heroImageUrl"].string,
            let imageUrl = NSURL(string: imageURLString) {
            heroImage.sd_setImageWithURL(imageUrl)
        }
        if let logoURLString = json["textImageUrl"].string,
            let imageUrl = NSURL(string: logoURLString) {
            textImage.sd_setImageWithURL(imageUrl)
        }
        if let isRequired = json["isRequired"].bool {
            required = isRequired
        }
        language = json["language"].string
        if let theOrder = json["order"].int {
            order = theOrder
        }
    }
    
}
