//
//  Hyecho+DispatchTime.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 7/13/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation

extension DispatchTime {
    func adding(seconds: Double) -> DispatchTime {
        return DispatchTime(
            uptimeNanoseconds: uptimeNanoseconds + UInt64(seconds * Double(NSEC_PER_SEC))
        )
    }
}
