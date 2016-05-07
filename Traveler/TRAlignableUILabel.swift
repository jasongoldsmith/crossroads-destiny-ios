//
//  AlignableUILabel.swift
//  GO90
//
//  Created by Thakur, Ashutosh Singh on 10/27/15.
//  Copyright © 2015 Verizon. All rights reserved.
//

import Foundation
import UIKit

class TRAlignableUILabel: UILabel {
    
    override func drawTextInRect(rect: CGRect) {
        
        var newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.width, rect.height)
        let fittingSize = sizeThatFits(rect.size)
        
        if contentMode == UIViewContentMode.Top {
            newRect.size.height = min(newRect.size.height, fittingSize.height)
        } else if contentMode == UIViewContentMode.Bottom {
            newRect.origin.y = max(0, newRect.size.height - fittingSize.height)
        }
        
        super.drawTextInRect(newRect)
    }
}
