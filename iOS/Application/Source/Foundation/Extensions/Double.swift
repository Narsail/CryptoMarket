//
//  Double.swift
//  CryptoMarket
//
//  Created by David Moeller on 12.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
extension Double {
    func string(fractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = fractionDigits
        if self > 1 {
            formatter.maximumFractionDigits = 2
        }
        return formatter.string(for: self)!
    }
}

extension Float {
    func string(fractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = fractionDigits
        if self > 1 {
            formatter.maximumFractionDigits = 2
        }
        return formatter.string(for: self)!
    }
}
