//
//  EndOfChapterView.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 9/28/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

class EndOfChapterView: PopupView {
    var nextChapterAction:(() -> ())?
    var stayHereAction: (()->())?
    @IBOutlet var stayHereButton: UIButton!
    @IBOutlet var onwardButton: UIButton!
    
    @IBAction func didPressStayHere(_ sender: Any) {
        stayHereAction?()
        cancelPopup()
    }
    
    @IBAction func didPressOnward(_ sender: Any) {
        nextChapterAction?()
    }
}
