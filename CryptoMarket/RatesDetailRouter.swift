//
//  RatesDetailRouter.swift
//  CryptoMarket
//
//  Created by David Moeller on 29/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import Charts
import DateHelper


class RatesDetailRouter: NavigationRouting {
	
	let root: UINavigationController
	var viewController: RatesDetailViewController?
	
	let ticker: Ticker
	let chartData: Results<ChartData>
	var notificationToken: NotificationToken? = nil
	
	var timer: Timer?
	
	init(root: UINavigationController, ticker: Ticker) {
		self.root = root
		self.ticker = ticker
		
		chartData = Store.realm.objects(ChartData.self).filter(NSPredicate(format: "market == %@", ticker.market!)).sorted(byProperty: "date")
		notificationToken = chartData.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
			
			guard let timeRangeControl = self?.viewController?.timeRangeSegmentedControl, let timeRangeItem = TimeRangeSegmentedControlItem(rawValue: Int(timeRangeControl.index)) else { return }
			
			guard let lineControl = self?.viewController?.lineSegmentedControl, let lineItem = LineSegmentedControlItem(rawValue: Int(lineControl.index)) else { return }
			
			self?.displayChartData(timeRange: timeRangeItem, lineItem: lineItem)
			
		}
		
		// Fetch Standard Data
		// Set Fetch Timer
		self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { _ in
			// Fetch Data
			self.fetchChartData(withMarket: self.ticker.market!)
		})
		self.timer?.fire()
		
	}
	
	func createViewController() -> RatesDetailViewController {
		var title: String!
		if let marketLabel = ticker.market?.label {
			let (firstAbbr, secondAbbr) = MarketAbbreviation.convertMarketName(marketName: marketLabel)
			title = "\(firstAbbr) <-> \(secondAbbr)"
		} else {
			title = "Market: Unknown"
		}
		return RatesDetailViewController(title: title, ticker: ticker)
	}
	
	func configure(_ viewController: RatesDetailViewController) {
		viewController.timeRangeSegmentedControl.addTarget(self, action: #selector(RatesDetailRouter.segmentedControllValueChanged(_:)), for: .valueChanged)
		viewController.lineSegmentedControl.addTarget(self, action: #selector(RatesDetailRouter.segmentedControllValueChanged(_:)), for: .valueChanged)
		return
	}
	
	func stop() {
		notificationToken?.stop()
		self.timer?.invalidate()
		dismiss()
		viewController = nil
	}
}

extension RatesDetailRouter {
	
	func fetchChartData(withMarket market: Market) {
		
		do {
			let ranges = try Store.chartDataToUpdate(forMarket: market)
			
			for range in ranges {
				NSLog("Fetch for Range: \(range)")
				PoloniexAPI.shared.fetchChartData(forMarket: market, withChartDataRange: range).map { chartData in
					Store.save(withChartData: chartData, withMarket: market)
				}.onFailure { error in
					NSLog("Error while fetching ChartData for Range: \(range) Error: \(error)")
				}
			}
			
		} catch {
			NSLog("Error while fetching Chart Data: \(error)")
		}
		
	}
	
}

extension RatesDetailRouter {
	
	func configureLineChartDataSet(dataSet: LineChartDataSet) -> LineChartDataSet {
		dataSet.setColor(projectColors.lineColor)
		dataSet.mode = .cubicBezier
		dataSet.cubicIntensity = 0.2
		dataSet.drawCirclesEnabled = false
		dataSet.lineWidth = 1.8
		dataSet.circleRadius = 4.0
		dataSet.drawFilledEnabled = true
		
		dataSet.fillAlpha = 1.0
		dataSet.fillColor = projectColors.lineColor
		dataSet.fillFormatter = CubicFillFormatter()
		
		return dataSet
	}
	
	@objc func segmentedControllValueChanged(_ sender: Any) {
		
		guard let timeRangeControl = self.viewController?.timeRangeSegmentedControl, let timeRangeItem = TimeRangeSegmentedControlItem(rawValue: Int(timeRangeControl.index)) else { return }
		
		guard let lineControl = self.viewController?.lineSegmentedControl, let lineItem = LineSegmentedControlItem(rawValue: Int(lineControl.index)) else { return }
		
		self.displayChartData(timeRange: timeRangeItem, lineItem: lineItem)
		
	}
	
	func displayChartData(timeRange: TimeRangeSegmentedControlItem, lineItem: LineSegmentedControlItem) {
		
		if let viewController = self.viewController {
			
			guard chartData.count > 0 else { return }
			
			let chartDataEntries = self.generateChartDataEntries(chartData: chartData, timeRangeItem: timeRange, lineItem: lineItem)
			
			let dataSet = LineChartDataSet(values: chartDataEntries, label: nil)
			
			let lineChartData = LineChartData(dataSet: configureLineChartDataSet(dataSet: dataSet))
			lineChartData.setDrawValues(false)
			
			if timeRange == .day {
				viewController.chartView.xAxis.valueFormatter = DayValueFormatter()
			} else {
				viewController.chartView.xAxis.valueFormatter = DateValueFormatter()
			}
			
			viewController.chartView.data = lineChartData
			
		}
		
	}
	
	func generateChartDataEntries(chartData: Results<ChartData>, timeRangeItem: TimeRangeSegmentedControlItem, lineItem: LineSegmentedControlItem) -> [ChartDataEntry] {
		
		var convertData: ((_ data: ChartData) -> (ChartDataEntry))!
		
		switch lineItem {
		case .open:
			convertData = { data in
				ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.open)
			}
		case .close:
			convertData = { data in
				ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.close)
			}
		case .low:
			convertData = { data in
				ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.low)
			}
		case .high:
			convertData = { data in
				ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.high)
			}
		}
		
		var predicate: NSPredicate!
		
		switch timeRangeItem {
		case .day:
			
			predicate = NSPredicate(format: "date > %@", Date().setTimeOfDate(0, minute: 0, second: 0) as NSDate)
		
		case .week:
			
			predicate = NSPredicate(format: "date > %@", Date().dateBySubtractingWeeks(1) as NSDate)
			
		case .month:
			
			predicate = NSPredicate(format: "date > %@", Date().dateBySubtractingMonths(1) as NSDate)
			
		case .year:
			
			predicate = NSPredicate(format: "date > %@", Date().dateBySubtractingMonths(12) as NSDate)

		case .all:
			return chartData.map(convertData)
		}
		
		return chartData.filter(predicate).map(convertData)

	}
	
}
