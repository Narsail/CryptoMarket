//
//  ChartDataRequest.swift
//  CryptoMarket
//
//  Created by David Moeller on 28/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

class ChartDataRequest: BackendAPIRequestProtocol {
	
	let marketLabel: String
	let startDate: Date
	let endDate: Date?
	let period: CandleStickPeriod
	
	init(marketLabel: String, period: CandleStickPeriod = .everyDay, startDate: Date, endDate: Date? = nil) {
		self.marketLabel = marketLabel
		self.startDate = startDate
		self.endDate = endDate
		self.period = period
	}
	
	var endpoint: String {
		return "/public?command=returnChartData&currencyPair=\(self.marketLabel)&start=\(self.startDate.timeIntervalSince1970)&end=\(self.endDate?.timeIntervalSince1970 ?? 9999999999)&period=\(self.period.rawValue)"
	}
	
	var method: NetworkService.Method {
		return .GET
	}
	
	var parameters: [String: Any]? {
		return nil
	}
	
	var headers: [String: String]? {
		return self.defaultJSONHeaders()
	}
	
}

enum CandleStickPeriod: Int {
	case everSixMinutes = 300
	case everyEighteenMinutes = 900
	case everyThirtyMinutes = 1800
	case everyTwoHours = 7200
	case everyFourHours = 14400
	case everyDay = 86400
}
