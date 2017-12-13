//
//  Hyecho+CGPoint.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 7/12/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

//Allows `CGPoint` to be put in `Set` and used as `Dictionary` keys
extension CGPoint: Hashable {
    public var hashValue: Int {
        return x.hashValue << 32 ^ y.hashValue
    }
}
