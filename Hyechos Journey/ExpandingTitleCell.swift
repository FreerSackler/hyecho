//
//  ExpandingTitleCell.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 5/4/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

class ExpandingTitleCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var line: UIView!
    
    var expanded: Bool = false
    
    private func rotateArrow() {
        let angle = expanded ? (Double.pi / 2.0) : 0
        let transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseOut,
            animations: {
                self.arrowImageView.transform = transform
        }, completion: nil)
    }
}
