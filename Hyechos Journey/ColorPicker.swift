//
//  ColorPicker.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 5/26/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

class ColorPicker: UIView {
    
    var colors: [UIColor] = []
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else {return}
        //Size of the circles based on constraint of the width
        let sizeFromWidth = (frame.width - CGFloat((colors.count + 1) * 8)) / CGFloat(colors.count)
        //Size of the circles based on constraint of the height
        let sizeFromHeight = frame.height - 16
        let size = min(sizeFromWidth, sizeFromHeight)
        for (i, color) in colors.enumerated() {
            //There are i+1 inter-circle spacings of 8, i circles, and half a circle between left edge and center of new circle
            let minX = CGFloat(i + 1) * 8 + size * CGFloat(i)
            let minY = 8
            let boundingRect = CGRect(x: minX, y: CGFloat(minY), width: size, height: size)
            context.setFillColor(color.cgColor)
            context.fillEllipse(in: boundingRect)
        }
    }
}
