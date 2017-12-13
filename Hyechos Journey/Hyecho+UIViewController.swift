//
//  Hyecho+UIViewController.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 2/23/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

//
//  Audio+UIViewController.swift
//  Audio
//
//  Created by Anders Boberg on 2/20/17.
//  Copyright © 2017 Anders Boberg. All rights reserved.
//

import UIKit

extension UIViewController {
    func addStatusBarView(withColor color: UIColor, shadow: Bool = false) {
        let statusBarTag = -1
        if let statusBarView = view.viewWithTag(statusBarTag) {
            statusBarView.backgroundColor = color
        } else {
            let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
            statusBarView.backgroundColor = color
            statusBarView.tag = statusBarTag
            view.addSubview(statusBarView)
            view.bringSubview(toFront: statusBarView)
            navigationController?.barHideOnSwipeGestureRecognizer.addTarget(self, action: #selector(UIViewController.updateStatusBarViewFrame))
            navigationController?.barHideOnTapGestureRecognizer.addTarget(self, action: #selector(UIViewController.updateStatusBarViewFrame))
            updateStatusBarViewFrame()
            statusBarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.didTouchStatusBarView)))
        }
        if shadow {
            addStatusBarViewShadow()
        }
    }
    
    var statusBarView: UIView? {
        let statusBarTag = -1
        return view.viewWithTag(statusBarTag)
    }
    
    func addStatusBarViewShadow() {
        statusBarView?.layer.masksToBounds = false
        statusBarView?.layer.shadowColor = UIColor.black.cgColor
        statusBarView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        statusBarView?.layer.shadowOpacity = 1
        statusBarView?.layer.shadowRadius = 3
    }
    
    func didTouchStatusBarView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func updateStatusBarViewFrame() {
        let statusBarTag = -1
        let statusBarFrame = UIApplication.shared.statusBarFrame
        let statusBarView = view.viewWithTag(statusBarTag)!
        if (navigationController?.isNavigationBarHidden) ?? true {
            statusBarView.frame = CGRect(x: 0, y: -2 * statusBarFrame.height, width: statusBarFrame.width, height: 3 * statusBarFrame.height)
        } else {
            let navigationBarFrame = navigationController!.navigationBar.frame
            statusBarView.frame = CGRect(x: 0, y: -2 * navigationBarFrame.height, width: statusBarFrame.width, height: 2 * navigationBarFrame.height)
        }
    }
}

/**
 Extension to present a popup view
 */
extension UIViewController {
    func present(
        popup: PopupView,
        insets: UIEdgeInsets,
        cornerRadius: CGFloat = 10,
        duration: Double = 0.4,
        delay: Double = 0.0,
        shadow: Bool = false,
        completion: (() -> ())? = nil
        ) {
        
        let startFrame = CGRect(
            origin: CGPoint(x: insets.left,
                            y: view.frame.height + view.frame.minY),
            size: CGSize(width: view.frame.width - insets.left - insets.right,
                         height: view.frame.height - insets.top - insets.bottom)
        )
        
        let destinationFrame = CGRect(
            origin: CGPoint(x: startFrame.minX,
                            y: insets.top),
            size: startFrame.size
        )
        
        let shadowView = UIView(frame: startFrame)
        shadowView.layer.cornerRadius = cornerRadius
        shadowView.layer.shadowRadius = 2.5
        shadowView.clipsToBounds = false
        shadowView.backgroundColor = .black
        /*
        shadowView.layer.shadowPath = CGPath(
            roundedRect: CGRect(x: 0, y: 0, width: startFrame.width, height: startFrame.height),
            cornerWidth: cornerRadius,
            cornerHeight: cornerRadius,
            transform: nil
        )*/
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        if(shadow) {
            shadowView.layer.shadowOpacity = 0.8
        }
        
        popup.cornerRadius = cornerRadius
        
        popup.frame = startFrame
        
        popup.clipsToBounds = true
        
        view.addSubview(popup)
        view.insertSubview(shadowView, belowSubview: popup)
        
        popup.onCancel {
            completion?()
            UIView.animate(
                withDuration: duration,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseIn,
                animations: {
                    popup.frame = startFrame
                    shadowView.frame = startFrame
            },
                completion: {
                    finished in
                    popup.removeFromSuperview()
                    shadowView.removeFromSuperview()
            }
            )
        }
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseOut,
            animations: {
                popup.frame = destinationFrame
                shadowView.frame = destinationFrame
        },
            completion: nil
        )
    }
}

