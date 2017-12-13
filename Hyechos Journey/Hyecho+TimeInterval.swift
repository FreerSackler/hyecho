//
//  Hyecho+TimeInterval.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 2/9/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import Foundation

extension TimeInterval {
    /**
     Returns string in format m:ss interpreting this TimeInterval(Double) as seconds.
     
     TODO: Handle times longer than 1 hr?
     */
    var timeString: String {
        let currentMinutes = Int(self) / 60
        let currentSeconds = Int(self.truncatingRemainder(dividingBy: 60))
        return String(format: "%01d:%02d", currentMinutes, currentSeconds)
    }
}
