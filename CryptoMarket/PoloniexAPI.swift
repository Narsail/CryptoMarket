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
	
	private let application: UIApplication?
	
	var errorCounter: Int = 0
	var consecutiveSuccessfulFetchesCounter: Int = 0
	
	private init() {
		configuration = BackendConfiguration(baseURL: URL(string:"https://poloniex.com/")!)
		queue = OperationQueue()
		application = UIApplication.shared
	}
	
	enum ResponseState {
		case success, error
	}
	
	func handleResponseState(state: ResponseState) {
		
		/// This Method handles the Response of the Requests.
		/// It will differentiate between a Slow Internet Connection and no Internet Connection. This is necessary due the repeptitive nature of the Applications requests.
		
		switch state {
		case .success:
			consecutiveSuccessfulFetchesCounter += 1
			if errorCounter > 6 {
				errorCounter = 4
			}
		case .error:
			consecutiveSuccessfulFetchesCounter = 0
			errorCounter += 1
		}
		
		if consecutiveSuccessfulFetchesCounter > 3 {
			errorCounter = 0
		}
		
		guard let delegate = application?.delegate as? AppDelegate else { return }
		
		if errorCounter == 3 {
			errorCounter += 1
			// Show warning for Slow Internet
			delegate.presentAlertView(alertType: .slowInternet)
		} else if errorCounter == 7 {
			errorCounter += 1
			// Show Error for no Internet
			delegate.presentAlertView(alertType: .noInternet)
		}
	}
	
	func fetchTickers() -> Future<[Ticker], BrightFutureErrorWrapper> {
		
		let promise = Promise<[Ticker], BrightFutureErrorWrapper>()
		
		application?.isNetworkActivityIndicatorVisible = true
		
		let request = TickerRequest()
		let arrayMapper = TickerArrayMapper()
		let mapper = TickerMapper()
		let operation = ListGETOperation(request: request, backendConfiguration: configuration, arrayMapper: ArrayMapper(base: arrayMapper), responseMapper: Mapper(base: mapper), success: { list in
			promise.success(list)
			self.handleResponseState(state: .success)
			self.application?.isNetworkActivityIndicatorVisible = false
		}, failure: { error in
			self.handleResponseState(state: .error)
			promise.failure(BrightFutureErrorWrapper.error(error: error))
			self.application?.isNetworkActivityIndicatorVisible = false
		})
		queue.addOperation(operation)
		
		return promise.future
	}
	
	func fetchChartData(forMarket market: Market, withChartDataRange chartDataRange: ChartDataRange) -> Future<[ChartData], BrightFutureErrorWrapper> {
		
		let (startDate, period) = ChartDataRange.convert(chartDataRange: chartDataRange)
		
		let promise = Promise<[ChartData], BrightFutureErrorWrapper>()
		
		application?.isNetworkActivityIndicatorVisible = true
		
		let request = ChartDataRequest(marketLabel: market.label, period: period, startDate: startDate, endDate: nil)
		let arrayMapper = ChartDataArrayMapper()
		let mapper = ChartDataMapper()
		let operation = ListGETOperation(request: request, backendConfiguration: configuration, arrayMapper: ArrayMapper(base: arrayMapper), responseMapper: Mapper(base: mapper), success: { list in
			self.handleResponseState(state: .success)
			promise.success(list)
			self.application?.isNetworkActivityIndicatorVisible = false
		}, failure: { error in
			self.handleResponseState(state: .error)
			promise.failure(BrightFutureErrorWrapper.error(error: error))
			self.application?.isNetworkActivityIndicatorVisible = false
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
