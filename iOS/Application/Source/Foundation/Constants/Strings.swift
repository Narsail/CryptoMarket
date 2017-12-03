//
//  Strings.swift
//  CryptoMarket
//
//  Created by David Moeller on 30.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation

enum Strings {
    
    enum AccessibilityLabels {
        static let close = NSLocalizedString("AccessibilityLabels.close", value:"Close", comment: "Close modal button accessibility label")
        static let faq = NSLocalizedString("AccessibilityLabels.faq", value: "Support Center", comment: "Support center accessibiliy label")
    }
    
    enum AddPortfolioItem {
        static let title = NSLocalizedString("AddPortfolioItem.coinTitle", value: "Add your Coin", comment: "")
        static let symbol = NSLocalizedString("AddPortfolioItem.symbol", value: "Symbol", comment: "")
        static let amount = NSLocalizedString("AddPortfolioItem.amount", value: "Amount", comment: "")
        static let addButton = NSLocalizedString("AddPortfolioItem.addButton", value: "Add", comment: "")
    }
}
