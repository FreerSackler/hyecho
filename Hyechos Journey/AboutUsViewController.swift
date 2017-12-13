//
//  AboutUsViewController.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 8/11/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation
import UIKit

class AboutUsViewController : UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var designLabel: UILabel!
    @IBOutlet weak var developmentLabel: UILabel!
    @IBOutlet weak var facultyAdvisorLabel: UILabel!
    
    override func viewDidLoad() {
        //insert
        self.navigationController?.isNavigationBarHidden = false
        let contentText = NSMutableAttributedString(string: contentLabel.text!)
        contentText.addAttributes([
            NSFontAttributeName: UIFont(name: "Georgia-Italic", size: 16)!
            ], range: NSRange(location: 0, length: 8)
        )
        contentLabel.attributedText = contentText
        
        let designText = NSMutableAttributedString(string: designLabel.text!)
        designText.addAttributes([
            NSFontAttributeName : UIFont(name: "Georgia-Italic", size: 16)!
            ], range: NSRange(location: 0, length: 7))
        designLabel.attributedText = designText
        
        let developmentText = NSMutableAttributedString(string: developmentLabel.text!)
        developmentText.addAttributes([
            NSFontAttributeName : UIFont(name: "Georgia-Italic", size: 16)!
            ], range: NSRange(location: 0, length: 12))
        developmentLabel.attributedText = developmentText
        
        let facultyAdvisorText = NSMutableAttributedString(string: facultyAdvisorLabel.text!)
        facultyAdvisorText.addAttributes([
            NSFontAttributeName : UIFont(name: "Georgia-Italic", size: 16)!
            ], range: NSRange(location: 0, length: 16))
        facultyAdvisorLabel.attributedText = facultyAdvisorText
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = contentView.bounds.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    @IBAction func pressedPrivacyPolicy(_ sender: UIButton) {
        
        if let url = NSURL(string:"https://www.si.edu/privacy/") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func pressedTermsOfUse (_ sender: UIButton) {
        
        if let url = NSURL(string:"https://www.si.edu/termsofuse/") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    
}
