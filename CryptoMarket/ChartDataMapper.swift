//
//  ExerciseSummaryMapper.swift
//  EMNetwork
//
//  Created by David Moeller on 21/09/2016.
//
//

import Foundation

extension ChartData : Mappable {}


final class ChartDataArrayMapper: ArrayMapping {
	
	typealias Item = ChartData
	
	func process(obj: Any?, mapper: ((Any?) throws -> Item)) throws -> [Item] {
		
		guard let json = obj as? [[String: Any]] else { throw MapperError.invalid }
		
		/* Unserialize all Ticker Objects */
		
		var items = [Item]()
		for jsonNode in json {
			let item = try mapper(jsonNode)
			items.append(item)
		}
		
		return items
		
	}
}


final class ChartDataMapper: Mapping {
	
	typealias Item = ChartData
	
	func map(obj: Any?) throws -> Item {
		return try extractJSON(obj: obj, parse: { json in
			
			var json = json
			
			guard let dateAsUnix = json["date"] as? Int else {
				throw MapperError.missingAttribute(attribute: "date")
			}
			
			let date = Date(timeIntervalSince1970: TimeInterval(dateAsUnix))
			
			guard let high = json["high"] as? Double else {
				throw MapperError.missingAttribute(attribute: "high")
			}
			
			guard let low = json["low"] as? Double else {
				throw MapperError.missingAttribute(attribute: "low")
			}
			
			guard let open = json["open"] as? Double else {
				throw MapperError.missingAttribute(attribute: "open")
			}
			
			guard let close = json["close"] as? Double else {
				throw MapperError.missingAttribute(attribute: "close")
			}
			
			guard let volume = json["volume"] as? Double else {
				throw MapperError.missingAttribute(attribute: "volume")
			}
			
			guard let quoteVolume = json["quoteVolume"] as? Double else {
				throw MapperError.missingAttribute(attribute: "quoteVolume")
			}
			
			guard let weightedAverage = json["weightedAverage"] as? Double else {
				throw MapperError.missingAttribute(attribute: "weightedAverage")
			}

			let chartData = ChartData()
			
			chartData.date = date
			chartData.high = high
			chartData.low = low
			chartData.open = open
			chartData.close = close
			chartData.volume = volume
			chartData.quoteVolume = quoteVolume
			chartData.weightedAverage = weightedAverage
			
			return chartData
		})
	}
	
	func serialize(item: Item) -> [String : Any] {
		return ["":""]
	}
}
