//
//  AppInfoPopupView.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 3/8/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

class AppInfoPopupView: PopupView {
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
