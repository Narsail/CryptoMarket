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
	
	init(root: UINavigationController, ticker: Ticker) {
		self.root = root
		self.ticker = ticker
		
		chartData = Store.realm.objects(ChartData.self).filter(NSPredicate(format: "market == %@", ticker.market!)).sorted(byProperty: "date")
		notificationToken = chartData.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
			
			if let control = self?.viewController?.segmentedControl {
				if let selectedItem = SegmentedControlItem(rawValue: Int(control.index)) {
					self?.displayChartData(item: selectedItem)
				}
			}
			
		}
		
		// Fetch Standard Data
		fetchChartData(withMarket: self.ticker.market!)
		
	}
	
	func createViewController() -> RatesDetailViewController {
		return RatesDetailViewController()
	}
	
	func configure(_ viewController: RatesDetailViewController) {
		viewController.segmentedControl.addTarget(self, action: #selector(RatesDetailRouter.segmentedControllValueChanged(_:)), for: .valueChanged)
		return
	}
	
	func stop() {
		notificationToken?.stop()
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
	
	func configureLineChartDataSet(dataSet: LineChartDataSet, withColor color: UIColor) -> LineChartDataSet {
		dataSet.mode = .cubicBezier
		dataSet.cubicIntensity = 0.2
		dataSet.drawCirclesEnabled = false
		dataSet.lineWidth = 1.8
		dataSet.circleRadius = 4.0
		
		return dataSet
	}
	
	@objc func segmentedControllValueChanged(_ sender: Any) {
		if let control = sender as? BetterSegmentedControl {
			if let selectedItem = SegmentedControlItem(rawValue: Int(control.index)) {
				self.displayChartData(item: selectedItem)
			}
		}
	}
	
	func displayChartData(item: SegmentedControlItem) {
		
		if let viewController = self.viewController {
			
			guard chartData.count > 0 else { return }
			
			let (openData, closeData) = self.generateChartDataEntries(chartData: chartData, item: item)
			
			let openDataSet = LineChartDataSet(values: openData, label: "Open")
			let closeDataSet = LineChartDataSet(values: closeData, label: "Close")
			
			let lineChartData = LineChartData(dataSets: [configureLineChartDataSet(dataSet: openDataSet, withColor: UIColor.white),
			                                             configureLineChartDataSet(dataSet: closeDataSet, withColor: UIColor.white)])
			
			viewController.chartView.data = lineChartData
			
		}
		
	}
	
	func generateChartDataEntries(chartData: Results<ChartData>, item: SegmentedControlItem) -> ([ChartDataEntry], [ChartDataEntry]) {
		
		var openData = [ChartDataEntry]()
		var closeData = [ChartDataEntry]()
		
		switch item {
		case .day:
			for data in chartData.filter("date > %@", Date().setTimeOfDate(0, minute: 0, second: 0)) {
				openData.append(ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.open))
				closeData.append(ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.close))
			}
		case .week:
			for data in chartData.filter("date > %@", Date().dateBySubtractingWeeks(1)) {
				openData.append(ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.open))
				closeData.append(ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.close))
			}
		case .month:
			for data in chartData.filter("date > %@", Date().dateBySubtractingMonths(1)) {
				openData.append(ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.open))
				closeData.append(ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.close))
			}
		case .year:
			for data in chartData.filter("date > %@", Date().dateBySubtractingMonths(12)) {
				openData.append(ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.open))
				closeData.append(ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.close))
			}
		case .all:
			for data in chartData {
				openData.append(ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.open))
				closeData.append(ChartDataEntry(x: data.date.timeIntervalSince1970, y: data.close))
			}
		}
		
		return (openData, closeData)

	}
	
}
