//
//  Hyecho+UIColor.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 5/8/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

/**
 A place to put color constants we might use in multiple places.
 
 Use like `UIColor.navigationBar`
 */
extension UIColor {
    static let navigationBar = UIColor(red: 43.0/255.0, green: 71.0/255.0, blue: 100.0/255.0, alpha: 1)
}

/**
 Convenience initializers for UIColor.
 */
extension UIColor {
    /**
     Lets you declare a color like UIColor(red: 43, green: 71, blue: 100) whithout having
     to convert to decimal or include alpha.
    */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /**
     Allows colors to be created from hex values.
     e.g. UIColor(hex: 0xFFFFFF)
    */
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
    /**
     
    */
    convenience init(hexString: String) {
        var string:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        
        guard string.characters.count == 6 else {
            self.init(cgColor: UIColor.gray.cgColor)
            return
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: string).scanHexInt32(&rgbValue)
        
        self.init(hex: Int(rgbValue))
    }
}
