//
//  Hyecho+UIButton.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 7/14/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

extension UIButton {
    private func image(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     For some reason can't set background color for a certain control state
     This creates an image using the given color and sets it as the background image...
     */
    func setBackgroundColor(_ color: UIColor, forControlState state: UIControlState) {
        let colorImage = image(withColor: color)
        setBackgroundImage(colorImage, for: state)
    }
}
