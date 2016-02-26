//
//  TRRequest.swift
//  Traveler
//
//  Created by Ashutosh on 2/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire

typealias TRRequestClosure = (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void
typealias TRValueCallBack = (value: Bool?) -> ()

enum ServerResponseError {
    case NoValidData
    case ServerError(message: String)
    case NoError
}

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