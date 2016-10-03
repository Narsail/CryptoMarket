//
//  ChartData.swift
//  CryptoMarket
//
//  Created by David Moeller on 27/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ChartData: Object {
	
	dynamic var market: Market?
	dynamic var date: Date = Date()
	dynamic var high: Double = 0
	dynamic var low: Double = 0
	dynamic var open: Double = 0
	dynamic var close: Double = 0
	dynamic var volume: Double = 0
	dynamic var quoteVolume: Double = 0
	dynamic var weightedAverage: Double = 0
	
}
