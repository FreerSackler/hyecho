//
//  Hyecho+UIView.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 3/20/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     Returns the portion of this view's frame which is within the bounds of it's superview(e.g. what is visible).
     The resulting frame is in terms of this view's coordinate system
    */
    func frameInSuperview() -> CGRect {
        let visibleMinX = max(frame.minX, 0)
        let visibleMaxX = min(frame.maxX, superview!.bounds.width)
        let visibleMinY = max(frame.minY, 0)
        let visibleMaxY = min(frame.maxY, superview!.bounds.height)
        let visibleRect = CGRect(x: visibleMinX,
                                 y: visibleMinY,
                                 width: visibleMaxX - visibleMinX,
                                 height: visibleMaxY - visibleMinY)
        return convert(visibleRect, from: superview!)
    }
    
}
