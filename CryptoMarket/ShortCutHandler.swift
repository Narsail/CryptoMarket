//
//  ShortCutHandler.swift
//  CryptoMarket
//
//  Created by David Moeller on 05/10/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import UIKit


func createShortCuts() {
	
	// Delete all Dynamic Shortcut Items
	
	let application = UIApplication.shared
	
	application.shortcutItems = nil
	
	// Get Favorite Rates
	
	let results = Store.realm.objects(Ticker.self).filter("favorite == True")
	
	var max = 3
	
	if results.count < 3 {
		max = results.count
	}
	
	var items = [UIApplicationShortcutItem]()
	
	for index in 0..<max {
		
		// Build ShortcutItems
		
		let ticker = results[index]
		
		let type = ShortCutType.typeForNumber(number: index)
		
		var title: String!
		
		if let marketLabel = ticker.market?.label {
			let (firstAbbr, secondAbbr) = MarketAbbreviation.convertMarketName(marketName: marketLabel)
			title = "\(firstAbbr) <-> \(secondAbbr)"
		} else {
			title = "Market: Unknown"
		}
		
		let shortCutIcon = UIApplicationShortcutIcon(templateImageName: "SelectedBookmark")
		let shortCutItem = UIApplicationShortcutItem(type: type.rawValue, localizedTitle: title, localizedSubtitle: nil, icon: shortCutIcon, userInfo: nil)
		
		items.append(shortCutItem)
		
	}
	
	application.shortcutItems = items
	
}

enum ShortCutType: String {
	case firstFavourite
	case secondFavourite
	case thirdFavourite
	
	static func typeForNumber(number: Int) -> ShortCutType {
		switch number {
		case 0:
			return .firstFavourite
		case 1:
			return .secondFavourite
		case 2:
			return .thirdFavourite
		default:
			return .firstFavourite
		}
	}
	
}
