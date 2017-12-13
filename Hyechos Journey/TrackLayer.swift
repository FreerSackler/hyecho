//
//  TrackLayer.swift
//  Pods
//
/*  Copyright (c) 2015 shushutochako <shushutochako22@gmail.com>
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

internal class TrackLayer: CAShapeLayer {
  struct Setting {
    var startAngle = Double()
    var barWidth = CGFloat()
    var barColor = UIColor()
    var trackingColor = UIColor()
  }
  internal var setting = Setting()
  internal var degree: Double = 0
  internal var hollowRadius: CGFloat {
    return (self.bounds.width * 0.5) - self.setting.barWidth
  }
  internal var currentCenter: CGPoint {
    return CGPoint(x: self.bounds.midX, y: self.bounds.midY)
  }
  internal var hollowRect: CGRect {
    return CGRect(
      x: self.currentCenter.x - self.hollowRadius,
      y: self.currentCenter.y - self.hollowRadius,
      width: self.hollowRadius * 2.0,
      height: self.hollowRadius * 2.0)
  }
  internal init(bounds: CGRect, setting: Setting) {
    super.init()
    self.bounds = bounds
    self.setting = setting
    self.cornerRadius = self.bounds.size.width * 0.5
    self.masksToBounds = true
    self.position = self.currentCenter
    self.backgroundColor = self.setting.barColor.cgColor
    self.mask()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override internal func draw(in ctx: CGContext) {
    self.drawTrack(ctx: ctx)
  }
  
  private func mask() {
    let maskLayer = CAShapeLayer()
    maskLayer.bounds = self.bounds
    let ovalRect = self.hollowRect
    let path =  UIBezierPath(ovalIn: ovalRect)
    path.append(UIBezierPath(rect: maskLayer.bounds))
    maskLayer.path = path.cgPath
    maskLayer.position = self.currentCenter
    maskLayer.fillRule = kCAFillRuleEvenOdd
    self.mask = maskLayer
  }
  
  private func drawTrack(ctx: CGContext) {
    let adjustDegree = Math.adjustDegree(self.setting.startAngle, degree: self.degree)
    let centerX = self.currentCenter.x
    let centerY = self.currentCenter.y
    let radius = min(centerX, centerY)
    ctx.setFillColor(self.setting.trackingColor.cgColor)
    ctx.beginPath()
    ctx.move(to: CGPoint(x: centerX, y: centerY))
    ctx.addArc(center: CGPoint(x: centerX, y: centerY),
               radius: radius,
               startAngle: CGFloat(Math.degreesToRadians(self.setting.startAngle)),
               endAngle: CGFloat(Math.degreesToRadians(adjustDegree)),
               clockwise: false)
    ctx.closePath();
    ctx.fillPath();
  }
}
