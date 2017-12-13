//
//  JournalCell.swift
//  Hyechos Journey
//
//  Created by Elijah Sattler on 3/30/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

class JournalCell: UICollectionViewCell {
    
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var imageView: UIImageView!

}

class JournalHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionLabel: UILabel!
    
}
