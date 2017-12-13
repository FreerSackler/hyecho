//
//  DrawView.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 5/18/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit
import AVFoundation

protocol DrawViewDelegate {
    func drawView(_ drawView: DrawView, didCompleteDrawingWithPercentage percentage: Double)
    func didBeginDrawing(atPercentage: Double)
    func didEndDrawing(atPercentage: Double)
    func shouldErase(point: CGPoint) -> Bool
}

class DrawView: UIImageView {
    var blendMode: CGBlendMode = .clear
    var lineWidth: CGFloat = 20
    var lineCap: CGLineCap = .round
    var lineAlpha: CGFloat = 1
    var lineJoin: CGLineJoin = .miter
    var lineColor: UIColor = .black
    var fillColor: UIColor = .black
    var shadowOffset: CGSize = .zero
    var shadowBlur: CGFloat = 0
    var shadowColor: UIColor? = nil
    var colorPicker: Bool = false {
        didSet {
            updateColorPickerViewFrame()
            colorPickerView.setNeedsDisplay()
        }
    }
    var originalBlanks: Set<CGPoint> = []
    
    var completionCutoffPercentage: Double = 0.8
    
    var delegate: DrawViewDelegate?
    
    private var currentPoint: CGPoint!
    private(set) var colorPickerView = ColorPicker()
    
    override var image: UIImage? {
        didSet {
            originalBlanks = completedPoints
        }
    }
    
    var completedPoints: Set<CGPoint> = []
    
    /*
    var completedPoints: Set<CGPoint> {
        var transparentCount = 0
        let imageHeight = image!.size.height
        let imageWidth = image!.size.width
        let numberOfPixels = Int(imageHeight * imageWidth)
        let imageData = image!.pixelData()!
        
        var completed: Set<CGPoint> = []
        for i in 0..<numberOfPixels {
            if imageData[4 * i] == 0 {
                transparentCount += 1
                let row = round(CGFloat(i) / imageWidth)
                let column = CGFloat(i % Int(imageWidth))
                completed.insert(CGPoint(x: round(CGFloat(column / imageWidth * 100)), y: round(row / imageHeight * 100)))
            }
        }
        //NOSE: x: 33 < 50, y: 50 < 66
        return completed
    }*/
    
    override func didMoveToWindow() {
        addSubview(colorPickerView)
        clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPoint = touches.first!.location(in: self)
        delegate?.didBeginDrawing(atPercentage: calculatePercentComplete())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let next = touches.first!.location(in: self)
        let percentX = round(next.x / frame.width * 100)
        let percentY = round(next.y / frame.height * 100)
        if delegate?.shouldErase(point: CGPoint(x: percentX, y: percentY)) ?? true {
            erase(from: currentPoint, to: next)
            completedPoints.insert(CGPoint(x: percentX, y: percentY))
        }
        currentPoint = next
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkCompletion()
        delegate?.didEndDrawing(atPercentage: calculatePercentComplete())
    }
    
    func updateColorPickerViewFrame() {
        if colorPicker {
            colorPickerView.frame = CGRect(x: 0, y: frame.height - 36, width: frame.width, height: 36)
        } else {
            colorPickerView.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 36)
        }
    }
    
    func updateCompletedPoints() {
        let imageHeight = image!.size.height
        let imageWidth = image!.size.width
        let imageData = image!.pixelData()!
        
        for x in 0..<100 {
            for y in 0..<100 {
                let pixelX = imageWidth * CGFloat(x) / 100
                let pixelY = imageHeight * CGFloat(y) / 100
                let index = Int(pixelX + pixelY * imageWidth)
                if imageData[4 * index] == 0 {
                    completedPoints.insert(CGPoint(x: x, y: y))
                }
            }
        }
        //NOSE: x: 33 < 50, y: 50 < 66
    }
    
    func calculatePercentComplete() -> Double {
        let imageHeight = image!.size.height
        let imageWidth = image!.size.width
        let numberOfPixels = Int(imageHeight * imageWidth)
        let imageData = image!.pixelData()!
        
        //Count the number of pixels that have an alpha of 0
        var transparentCount = 0
        for i in 0..<numberOfPixels {
            if imageData[4 * i] == 0 {
                transparentCount += 1
            }
        }
        let progress = Double(transparentCount) / Double(numberOfPixels)
        return progress
    }
    
    func checkCompletion() {
        updateCompletedPoints()
        let progress = calculatePercentComplete()
        if progress > completionCutoffPercentage {
            delegate?.drawView(self, didCompleteDrawingWithPercentage: progress)
        }
    }
    
    func erase(from: CGPoint, to: CGPoint) {
        UIGraphicsBeginImageContext(self.frame.size)
        
        if let img = image {
            let fitRect = AVMakeRect(aspectRatio: img.size, insideRect: self.bounds)
            img.draw(in: fitRect)
        }
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setLineCap(lineCap)
        context.setLineWidth(lineWidth)
        context.setBlendMode(blendMode)
        context.setAlpha(lineAlpha)
        context.setLineJoin(lineJoin)
        context.setFillColor(fillColor.cgColor)
        context.setStrokeColor(lineColor.cgColor)
        context.setShadow(offset: shadowOffset, blur: shadowBlur, color: shadowColor?.cgColor)
        context.move(to: from)
        context.addLine(to: to)
        context.strokePath()
        
        image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
    }
    
    

}
