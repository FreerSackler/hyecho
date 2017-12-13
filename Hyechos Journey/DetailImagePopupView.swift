//
//  DetailImagePopupView.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 3/8/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

class DetailImagePopupView: PopupView {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var blurView: UIVisualEffectView!
    
    private var doubleTapGestureRecognizer: UITapGestureRecognizer?
    
    override func didMoveToWindow() {
        blurView.layer.cornerRadius = blurView.frame.height / 2
        if doubleTapGestureRecognizer == nil {
            createDoubleTapGestureRecognizer()
        }
    }
    
    private func createDoubleTapGestureRecognizer() {
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailImagePopupView.didDoubleTap(sender:)))
        doubleTapGestureRecognizer?.numberOfTapsRequired = 2
        doubleTapGestureRecognizer?.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapGestureRecognizer!)
    }
    
    private func zoomRect(toScale to: CGFloat, withCenter center: CGPoint) -> CGRect {
        //Height of the rectangle to zoom to
        let height = imageView.bounds.size.height / to
        //Width of the rectangle to zoom to
        let width = imageView.bounds.size.width / to
        let minX = center.x - width / 2
        let minY = center.y - height / 2
        
        return CGRect(x: minX, y: minY, width: width, height: height)
    }
    
    func didDoubleTap(sender: UITapGestureRecognizer) {
        if scrollView.zoomScale < scrollView.maximumZoomScale {
            let rect = zoomRect(
                toScale: 2 * scrollView.zoomScale,
                withCenter: sender.location(in: imageView)
            )
            scrollView.zoom(to: rect, animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    @IBAction func didPressCancel(_ sender: UIButton) {
        cancelPopup()
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}

extension DetailImagePopupView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
