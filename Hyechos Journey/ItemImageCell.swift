//
//  ItemImageView.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 5/8/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

class ItemImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var zoomInImage: UIImageView! {
        didSet {
            zoomInImage.layer.cornerRadius = 10
            zoomInImage.layer.masksToBounds = true
        }
    }
}
