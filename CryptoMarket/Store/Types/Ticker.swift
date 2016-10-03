//
//  Ticker.swift
//  CryptoMarket
//
//  Created by David Moeller on 27/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Ticker: Object {
	
	dynamic var sortingLabel: String = "Unknown"
	
	dynamic var market: Market?
	dynamic var id: Int = 0
	dynamic var priorLast: Double = 0
	dynamic var last: Double = 0
	dynamic var lowestAsk: Double = 0
	dynamic var highestBid: Double = 0
	dynamic var percentChange: Double = 0
	dynamic var baseVolume: Double = 0
	dynamic var quoteVolume: Double = 0
	dynamic var isFrozen: Int = 0
	dynamic var high24hr: Double = 0
	dynamic var low24hr: Double = 0
	
	dynamic var favorite: Bool = false
	
	func toggleFavorite() {
		
		self.favorite = !self.favorite
		
		setSortingLabel()
		
	}
	
	func setSortingLabel() {
		var favoriteInt = 1
		
		if self.favorite {
			favoriteInt = 0
		}
		
		self.sortingLabel = "\(favoriteInt)-\(self.market?.label)"
	}
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
}
