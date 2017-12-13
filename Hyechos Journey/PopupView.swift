//
//  PopupView.swift
//  Audio
//
//  Created by Anders Boberg on 2/22/17.
//  Copyright © 2017 Anders Boberg. All rights reserved.
//

import UIKit

/**
 Subclass this to create individual Popup views. Then use presentPopup in view controller to present.
 Make sure to call cancelPopup when you want to popup to disappear.
 */
class PopupView: UIView {
    
    fileprivate var callbacks:[()->()] = []
    
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    func onCancel(_ callback: @escaping ()->()) {
        callbacks.append(callback)
    }
    
    func cancelPopup() {
        for callback in callbacks {
            callback()
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
