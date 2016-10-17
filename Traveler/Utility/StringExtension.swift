//
//  NSStringExtension.swift
//  Traveler
//
//  Created by Ashutosh on 10/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

extension String {
    
    var isPlayStationVerified: Bool {
        return rangeOfString("^[a-zA-Z0-9-_]+$", options: .RegularExpressionSearch) != nil
    }
    
}