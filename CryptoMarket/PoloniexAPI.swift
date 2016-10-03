//
//  PoloniexAPI.swift
//  CryptoMarket
//
//  Created by David Moeller on 27/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import BrightFutures
import DateHelper

public class PoloniexAPI {
	
	public static let shared = PoloniexAPI()
	
	private let configuration: BackendConfiguration
	private let queue: OperationQueue
	
	private init() {
		configuration = BackendConfiguration(baseURL: URL(string:"https://poloniex.com/")!)
		queue = OperationQueue()
	}
	
	func fetchTickers() -> Future<[Ticker], BrightFutureErrorWrapper> {
		
		let promise = Promise<[Ticker], BrightFutureErrorWrapper>()
		
		let request = TickerRequest()
		let arrayMapper = TickerArrayMapper()
		let mapper = TickerMapper()
		let operation = ListGETOperation(request: request, backendConfiguration: configuration, arrayMapper: ArrayMapper(base: arrayMapper), responseMapper: Mapper(base: mapper), success: { list in
			promise.success(list)
		}, failure: { error in
			promise.failure(BrightFutureErrorWrapper.error(error: error))
		})
		queue.addOperation(operation)
		
		return promise.future
	}
	
	func fetchChartData(forMarket market: Market, withChartDataRange chartDataRange: ChartDataRange) -> Future<[ChartData], BrightFutureErrorWrapper> {
		
		let (startDate, period) = ChartDataRange.convert(chartDataRange: chartDataRange)
		
		let promise = Promise<[ChartData], BrightFutureErrorWrapper>()
		
		let request = ChartDataRequest(marketLabel: market.label, period: period, startDate: startDate, endDate: nil)
		let arrayMapper = ChartDataArrayMapper()
		let mapper = ChartDataMapper()
		let operation = ListGETOperation(request: request, backendConfiguration: configuration, arrayMapper: ArrayMapper(base: arrayMapper), responseMapper: Mapper(base: mapper), success: { list in
			promise.success(list)
		}, failure: { error in
			promise.failure(BrightFutureErrorWrapper.error(error: error))
		})
		queue.addOperation(operation)
		
		return promise.future
	}
	
}

enum BrightFutureErrorWrapper: Error {
	case error(error: Error)
}

enum ChartDataRange {
	
	case today
	case thisWeek
	case lastThreeMonth
	case wholeTime
	
	static func convert(chartDataRange: ChartDataRange) -> (Date, CandleStickPeriod) {
		switch chartDataRange {
		case .today:
			return (Date.yesterday(), .everSixMinutes)
		case .thisWeek:
			return (Date().dateBySubtractingWeeks(1).dateBySubtractingDays(2), .everyTwoHours)
		case .lastThreeMonth:
			return (Date().dateBySubtractingMonths(3), .everyFourHours)
		case .wholeTime:
			return (Date().dateBySubtractingMonths(60), .everyDay)
		}
	}
	
}
