//
//  TRApplicationManager.swift
//  Traveler
//
//  Created by Ashutosh on 2/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger

class TRApplicationManager: NSObject {
    
    // Shared Instance
    static let sharedInstance = TRApplicationManager()
    
    //XCGLogger Instance
    let log = XCGLogger.defaultInstance()
    
    //StoryBoard Manager Instance
    let stroryBoardManager = TRStoryBoardManager()
    
    //Event Info Objet
    var eventsList: [TREventInfo] = []
    
    //Activity List
    var activityList: [TRActivityInfo] = []
    
    private override init() {
        super.init()
        
        #if DEBUG
            self.log.setup(.Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
            self.log.xcodeColorsEnabled = true
        #else
            self.log.setup(.Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        #endif
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

