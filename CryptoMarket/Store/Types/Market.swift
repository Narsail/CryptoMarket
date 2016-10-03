//
//  Market.swift
//  CryptoMarket
//
//  Created by David Moeller on 27/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Market: Object {
	
	dynamic var label: String = ""
	
	let tickers = LinkingObjects(fromType: Ticker.self, property: "market")
	var ticker: Ticker? { return tickers.first }
	
	let chartData = LinkingObjects(fromType: ChartData.self, property: "market")
	
	override static func primaryKey() -> String? {
		return "label"
	}
	
}
