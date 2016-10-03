//
//  Store.swift
//  CryptoMarket
//
//  Created by David Moeller on 27/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import BrightFutures
import DateHelper

class Store {
	
	static var realm: Realm {
		return try! Realm()
	}
	
	static func getOrCreateMarket(withLabel label: String) throws -> Market {
		
		if let market = realm.object(ofType: Market.self, forPrimaryKey: label) { return market } else {
			
			let market = Market()
			market.label = label
			
			try realm.write {
				realm.add(market)
			}
			
			return market
		}
	}
	
	static func save(withTickers tickers: [Ticker]) -> Future<NoValue, BrightFutureErrorWrapper> {
		
		// Will be updated upon their PrimaryKey or added if no earlier item is existing
		let promise = Promise<NoValue, BrightFutureErrorWrapper>()
		
		do {
			for ticker in tickers {
				
				if let oldTicker = realm.object(ofType: Ticker.self, forPrimaryKey: ticker.id) {
					ticker.favorite = oldTicker.favorite
					ticker.priorLast = oldTicker.last
				}
				
			}
			
			try realm.write {
				realm.add(tickers, update: true)
			}
		} catch {
			promise.failure(BrightFutureErrorWrapper.error(error: error))
		}
		
		return promise.future
		
	}
	
	static func save(withChartData chartData: [ChartData], withMarket market: Market) -> Future<NoValue, BrightFutureErrorWrapper> {
		
		// Will be updated upon their PrimaryKey or added if no earlier item is existing
		let promise = Promise<NoValue, BrightFutureErrorWrapper>()
		
		do {
			
			// Get Data Properties for old Data
			
			var dates = [NSDate]()
			
			for data in chartData {
				
				data.market = market
				dates.append(data.date as NSDate)
				
			}
			
			let predicate = NSPredicate(format: "market == %@ AND date IN %@", market, dates)
			let oldData = realm.objects(ChartData.self).filter(predicate)
			
			// Delete old Data
			
			try realm.write {
				realm.delete(oldData)
			}
			
			// Add New Data
			
			try realm.write {
				realm.add(chartData)
			}
			
		} catch {
			promise.failure(BrightFutureErrorWrapper.error(error: error))
		}
		
		return promise.future
		
	}
	
	static func toggleTickerFavorite(withTickerID tickerID: Int) {
		
		guard let ticker = realm.object(ofType: Ticker.self, forPrimaryKey: tickerID) else {
			return
		}
		
		try? realm.write {
			ticker.toggleFavorite()
		}
		
	}
	
	static func chartDataToUpdate(forMarket market: Market) throws -> [ChartDataRange] {
		
		let chartData = realm.objects(ChartData.self).filter(NSPredicate(format: "market == %@", market)).sorted(byProperty: "date")
		
		if let data = chartData.last {
			
			if data.date.isToday() {
				
				return [.today]
				
			} else {
				
				// Delete Yesterdays Data
				try realm.write {
					realm.delete(chartData.filter(NSPredicate(format: "date > %@", Date().dateBySubtractingDays(2) as NSDate)))
				}
				
				return [.thisWeek, .today]
				
			}
			
		}
		
		return [.wholeTime, .lastThreeMonth, .thisWeek, .today]
		
	}
	
	
}
