//
//  Hyecho+UITableView.swift
//  Hyechos Journey
//
//  Created by Anders Boberg on 2/6/17.
//  Copyright © 2017 hyecho. All rights reserved.
//

import UIKit

extension UITableView {
    
    /**
     Allows for the use of enums with string raw values to be used when dequeueing cells.
    */
    func dequeueReusableCell<T:RawRepresentable>(withIdentifier identifier: T) -> UITableViewCell? where T.RawValue == String {
        return dequeueReusableCell(withIdentifier: identifier.rawValue)
    }
    
    /**
     Allows for the use of enums with string raw values to be used when dequeueing cells.
     */
    func dequeueReusableCell<T:RawRepresentable>(withIdentifier identifier: T, for indexPath: IndexPath) -> UITableViewCell? where T.RawValue == String {
        return dequeueReusableCell(withIdentifier: identifier.rawValue, for: indexPath)
    }
}
