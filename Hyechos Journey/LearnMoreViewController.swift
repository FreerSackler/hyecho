//
//  LearnMoreViewController.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 7/21/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation
import UIKit

class LearnMoreViewController : UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var hyechoJourneyTextView: UITextView!
    
    @IBOutlet weak var encounteringBuddhaTextView: UITextView!
    
    @IBOutlet weak var freerSacklerTextView: UITextView!
    override func viewDidLoad() {
        //insert
        self.navigationController?.isNavigationBarHidden = false
        
        
        let customString = NSMutableAttributedString(string: hyechoJourneyTextView.text!)
        //customString.addAttribute(NSFontAttributeName, value: UIFont(name: "Georgia-Italic", size: 16)! , range: NSRange(location: 47, length: 39))
        customString.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 16)!, range: NSRange(location: 0, length: customString.length))
        customString.addAttributes(
            [
                NSFontAttributeName: UIFont(name: "Georgia-Italic", size: 16)!,
                NSLinkAttributeName: NSURL(string: "http://press.uchicago.edu/ucp/books/book/chicago/H/bo27315039.html")!
            ],
            range: NSRange(location: 47, length: 39)
        )
        hyechoJourneyTextView.attributedText = customString
        
        let customString2 = NSMutableAttributedString(string: encounteringBuddhaTextView.text!)
        //customString2.addAttribute(NSFontAttributeName, value: UIFont(name: "Georgia-Italic", size: 16)! , range: NSRange(location: 39, length: 23))
        customString2.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 16)!, range: NSRange(location: 0, length: customString2.length))
        customString2.addAttributes(
            [
                NSFontAttributeName: UIFont(name: "Georgia-Italic", size: 16)!,
                NSLinkAttributeName: NSURL(string: "https://www.freersackler.si.edu/exhibition/encountering-the-buddha-art-and-practice-across-asia/")!
            ],
            range: NSRange(location: 66, length: 23)
        )
        encounteringBuddhaTextView.attributedText = customString2
        
        let customString3 = NSMutableAttributedString(string: freerSacklerTextView.text!)
        customString3.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirNext-Regular", size: 16)!, range: NSRange(location: 0, length: customString3.length))
        customString3.addAttributes(
            [
                NSFontAttributeName: UIFont(name: "Georgia-Italic", size: 16)!,
                NSLinkAttributeName: NSURL(string: "http://www.asia.si.edu/")!
            ],
            range: NSRange(location: 56, length: 13)
        )
        freerSacklerTextView.attributedText = customString3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    @IBAction func didPressLinkOne(_ sender: UIButton) {
        UIApplication.shared.open(
            URL(string: "http://www.museum.go.kr/site/eng/home")!,
            options: [:],
            completionHandler: nil
        )
    }
    @IBAction func didPressLinkTwo(_ sender: UIButton) {
        UIApplication.shared.open(
            URL(string: "http://www.narahaku.go.jp/english/index_e.html")!,
            options: [:],
            completionHandler: nil
        )
    }
    @IBAction func didPressLinkThree(_ sender: UIButton) {
        UIApplication.shared.open(
            URL(string: "http://www.tnm.jp/?lang=en")!,
            options: [:],
            completionHandler: nil
        )
    }
    @IBAction func didPressLinkFour(_ sender: UIButton) {
        UIApplication.shared.open(
            URL(string: "http://idp.bl.uk/")!,
            options: [:],
            completionHandler: nil
        )
    }
    @IBAction func didPressLinkFive(_ sender: UIButton) {
        UIApplication.shared.open(
            URL(string: "http://english.visitkorea.or.kr/enu/ATR/SI_EN_3_1_1_1.jsp?cid=268141")!,
            options: [:],
            completionHandler: nil
        )
    }
    @IBAction func didPressLinkSix(_ sender: UIButton) {
        UIApplication.shared.open(
            URL(string: "http://www.guimet.fr/en/home")!,
            options: [:],
            completionHandler: nil
        )
    }
    
    @IBAction func didPressMuseumLink(_ sender: UIButton) {
        if let url = NSURL(string: (sender.titleLabel?.text)!) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
        
    }
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = contentView.bounds.size
    }
}
