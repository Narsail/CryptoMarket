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
    
    enum SortCell {
        static let title = NSLocalizedString("SortCell.title", value: "Sort by", comment: "")
        static let cap = NSLocalizedString("SortCell.cap", value: "Market Cap", comment: "")
        static let name = NSLocalizedString("SortCell.name", value: "Coin Name", comment: "")
        static let change = NSLocalizedString("SortCell.change", value: "24 Change", comment: "")
    }
    
    enum TodayWidget {
        static let unlock = NSLocalizedString("SortCell.unlock", value: "Please unlock your iPhone.", comment: "")
        static let title = NSLocalizedString("SortCell.title", value: "Your Portfolio", comment: "")
        static let empty = NSLocalizedString("SortCell.empty", value: "Your Portfolio is empty.", comment: "")
    }
    
    enum NavigationBarItems {
        static let portfolio = NSLocalizedString("NavigationBarItems.portfolio", value: "Portfolio", comment: "")
        static let cryptocurrencies = NSLocalizedString("NavigationBarItems.cryptocurrencies", value: "Cryptocurrencies", comment: "")
    }
    
    enum RefreshControl {
        static let title = NSLocalizedString("RefreshControl.title", value: "Pull to refresh", comment: "Pull to refresh")
    }
}
