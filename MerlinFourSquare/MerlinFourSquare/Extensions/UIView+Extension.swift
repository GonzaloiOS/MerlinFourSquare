//
//  UIView+Extension.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/18/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
