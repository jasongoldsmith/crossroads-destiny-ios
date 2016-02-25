//
//  TRRequest.swift
//  Traveler
//
//  Created by Ashutosh on 2/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire

public typealias TRRequestClosure = (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void

class TRRequest: NSObject {
    
    var shouldDrop: Bool?
    var params:[String: AnyObject]?
    var URLMethod: Alamofire.Method?
    var encodingType: ParameterEncoding?
    var requestHandler: TRRequestClosure?
    
    override init() {
        super.init()
        self.shouldDrop = false
        self.URLMethod = .POST
        self.encodingType = .JSON
    }
}