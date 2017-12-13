//
//  ChapterHeaderCell.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 5/11/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

class ChapterHeaderCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private var topShadowView: UIView?
    private var bottomShadowView: UIView?
    
    override func didMoveToSuperview() {
        
        
        bottomShadowView?.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 5)
        bottomShadowView?.layer.shadowPath = CGPath(rect: CGRect(x: 0, y: 0, width: frame.width, height: 5), transform: nil)
        bottomShadowView?.layer.masksToBounds = false
        bottomShadowView?.layer.shadowColor = UIColor.black.cgColor
        bottomShadowView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        bottomShadowView?.layer.shadowOpacity = 1
        bottomShadowView?.layer.shadowRadius = 3
    }
}

