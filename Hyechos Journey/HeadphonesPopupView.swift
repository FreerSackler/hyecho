//
//  HeadphonesPopupView.swift
//  Audio
//
//  Created by Anders Boberg on 2/22/17.
//  Copyright © 2017 Anders Boberg. All rights reserved.
//

import UIKit

class HeadphonesPopupView: PopupView {
    
    @IBOutlet var textView: UITextView!
    
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
