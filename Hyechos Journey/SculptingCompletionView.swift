//
//  SculptingCompletionView.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 7/12/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

/**
 Draws a rectangular bar in the view with rounded ends. Fills the first `completion` proportion of the total bar with the `fillColor`.
 */
class SculptingCompletionView: UIView {
    
    /**
     The proportion of the bar which should be filled in. Between 0 and 1.
     */
    var completion: CGFloat = 0
    
    var borderWidth: CGFloat = 1
    var borderColor: UIColor = .white
    var fillColor: UIColor = .green
    
    private var borderLayer: CAShapeLayer!
    private var fillLayer: CALayer!
    private var fillMaskLayer: CAShapeLayer!
    
    /**
     The distance from the edge of the view to the start of the loading bar
     */
    var insets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    func set(completion: CGFloat, animated: Bool = true) {
        self.completion = completion
        if animated {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.25)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        }
        layoutFill()
        if animated {
            CATransaction.commit()
        }
    }
    
    private func layoutBorder() {
        let endArcRadius = (frame.height - insets.bottom - insets.top) / 2
        let borderPath = UIBezierPath(
            roundedRect: CGRect(
                x: insets.left,
                y: insets.top,
                width: frame.width - insets.left - insets.right,
                height: frame.height - insets.top - insets.bottom
            ),
            cornerRadius: endArcRadius
        )
        if borderLayer == nil {
            borderLayer = CAShapeLayer()
            layer.addSublayer(borderLayer)
        }
        borderLayer.path = borderPath.cgPath
        borderLayer.cornerRadius = endArcRadius
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = 1
        borderLayer.fillColor = nil
    }
    
    private func layoutFillMask() {
        let endArcRadius = (frame.height - insets.bottom - insets.top) / 2
        if fillMaskLayer == nil {
            fillMaskLayer = CAShapeLayer()
            layer.addSublayer(fillMaskLayer)
        }
        //Same as border except smaller by the an amount of `borderWidth` so that the border strok shows up better
        //Note that since this is a mask of the fill layer it is in the coordinate system of the filllayer not the main layer of the view.
        fillMaskLayer.path = UIBezierPath(
            roundedRect: CGRect(
                x: borderWidth,
                y: borderWidth,
                width: frame.width - insets.left - insets.right - 2 * borderWidth,
                height: frame.height - insets.top - insets.bottom - 2 * borderWidth
            ),
            cornerRadius: endArcRadius - borderWidth
            ).cgPath
    }
    
    func layoutFill() {
        if fillLayer == nil {
            fillLayer = CALayer()
            layer.addSublayer(fillLayer)
        }
        fillLayer.backgroundColor = fillColor.cgColor
        fillLayer.frame = CGRect(
            x: insets.left,
            y: insets.top,
            width: (bounds.width - insets.left - insets.right) * completion,
            height: bounds.height - insets.top - insets.bottom
        )
        fillLayer.mask = fillMaskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBorder()
        layoutFillMask()
        layoutFill()
    }
}
