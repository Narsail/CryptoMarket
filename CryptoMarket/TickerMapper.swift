//
//  ExerciseSummaryMapper.swift
//  EMNetwork
//
//  Created by David Moeller on 21/09/2016.
//
//

import Foundation

extension Ticker : Mappable {}


final class TickerArrayMapper: ArrayMapping {
	
	typealias Item = Ticker
	
	func process(obj: Any?, mapper: ((Any?) throws -> Item)) throws -> [Item] {
		guard let json = obj as? [String: Any] else { throw MapperError.invalid }
		
		/* Map Dictionary to Array for TickerMapper */
		var newArray = [[String: Any]]()
		
		for (key, value) in json {
			
			guard var tickerDict = value as? [String: Any] else {
				throw MapperError.invalid
			}
			
			tickerDict["market"] = key
			
			newArray.append(tickerDict)
		}
		
		/* Unserialize all Ticker Objects */
		
		var items = [Item]()
		for jsonNode in newArray {
			let item = try mapper(jsonNode)
			items.append(item)
		}
		
		return items
		
	}
}


final class TickerMapper: Mapping {
	
	typealias Item = Ticker
	
	func map(obj: Any?) throws -> Item {
		return try extractJSON(obj: obj, parse: { json in
			
			var json = json
			
			guard let marketLabel = json["market"] as? String else {
				throw MapperError.missingAttribute(attribute: "market")
			}
			
			let market = try Store.getOrCreateMarket(withLabel: marketLabel)
			
			guard let lastString = json["last"] as? String, let last = Double(lastString) else {
				throw MapperError.missingAttribute(attribute: "last")
			}
			
			guard let lowestAskString = json["lowestAsk"] as? String, let lowestAsk = Double(lowestAskString) else {
				throw MapperError.missingAttribute(attribute: "lowestAsk")
			}
			
			guard let highestBidString = json["highestBid"] as? String, let highestBid = Double(highestBidString) else {
				throw MapperError.missingAttribute(attribute: "highestBid")
			}
			
			guard let percentChangeString = json["percentChange"] as? String, let percentChange = Double(percentChangeString) else {
				throw MapperError.missingAttribute(attribute: "percentChange")
			}

			guard let baseVolumeString = json["baseVolume"] as? String, let baseVolume = Double(baseVolumeString) else {
				throw MapperError.missingAttribute(attribute: "baseVolume")
			}
			
			guard let quoteVolumeString = json["quoteVolume"] as? String, let quoteVolume = Double(quoteVolumeString) else {
				throw MapperError.missingAttribute(attribute: "quoteVolume")
			}
			
			guard let isFrozenString = json["isFrozen"] as? String, let isFrozen = Int(isFrozenString) else {
				throw MapperError.missingAttribute(attribute: "isFrozen")
			}
			
			guard let high24hrString = json["high24hr"] as? String, let high24hr = Double(high24hrString) else {
				throw MapperError.missingAttribute(attribute: "high24hr")
			}
			
			guard let low24hrString = json["low24hr"] as? String, let low24hr = Double(low24hrString) else {
				throw MapperError.missingAttribute(attribute: "low24hr")
			}
			
			guard let id = json["id"] as? Int else {
				throw MapperError.missingAttribute(attribute: "id")
			}

			let ticker = Ticker()
			ticker.market = market
			ticker.id = id
			ticker.last = last
			ticker.lowestAsk = lowestAsk
			ticker.highestBid = highestBid
			ticker.percentChange = percentChange
			ticker.baseVolume = baseVolume
			ticker.quoteVolume = quoteVolume
			ticker.isFrozen = isFrozen
			ticker.high24hr = high24hr
			ticker.low24hr = low24hr
			
			ticker.setFavorite(withFavorite: false)
			
			return ticker
		})
	}
	
	func serialize(item: Item) -> [String : Any] {
		return ["":""]
	}
}
