//
//  RatesDetailViewController.swift
//  CryptoMarket
//
//  Created by David Moeller on 29/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit
import Charts
import Stevia

class RatesDetailViewController: UIViewController {
	
	let chartView: LineChartView = {
		let view = LineChartView()
		view.isUserInteractionEnabled = false
		view.chartDescription?.enabled = false
		view.legend.enabled = false
		
		view.rightAxis.enabled = false
		
		view.xAxis.enabled = true
		view.xAxis.drawGridLinesEnabled = false
		view.xAxis.labelPosition = .bottom
		view.xAxis.labelCount = 3
		
		view.maxHighlightDistance = 300.0
		return view
	}()
	let timeRangeSegmentedControl: BetterSegmentedControl = {
		let control = BetterSegmentedControl(frame: CGRect(), titles: [TimeRangeSegmentedControlItem.day.toString(), TimeRangeSegmentedControlItem.week.toString(), TimeRangeSegmentedControlItem.month.toString(), TimeRangeSegmentedControlItem.year.toString(), TimeRangeSegmentedControlItem.all.toString()], index: 0, backgroundColor: projectColors.segmentedControlBackgroundColor, titleColor: projectColors.segmentedTitleColor, indicatorViewBackgroundColor: projectColors.segmentedControlIndicatorColor, selectedTitleColor: projectColors.segmentedSelectedTitleColor)
		control.cornerRadius = 10.0
		return control
	}()
	let lineSegmentedControl: BetterSegmentedControl = {
		let control = BetterSegmentedControl(frame: CGRect(), titles: [LineSegmentedControlItem.open.toString(), LineSegmentedControlItem.close.toString(), LineSegmentedControlItem.low.toString(), LineSegmentedControlItem.high.toString()], index: 0, backgroundColor: projectColors.segmentedControlBackgroundColor, titleColor: projectColors.segmentedTitleColor, indicatorViewBackgroundColor: projectColors.segmentedControlIndicatorColor, selectedTitleColor: projectColors.segmentedSelectedTitleColor)
		control.cornerRadius = 10.0
		return control
	}()
	
	// MARK: - Prime View
	
	let leftPrimaryView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.flatGray()
		return view
	}()
	let percentageChangeLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.black
		return label
	}()
	
	let rightPrimaryView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		return view
	}()
	let lastValueLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	// MARK: - Information View Part
	
	let informationView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		return view
	}()
	
	let lowestAskLabel: UILabel = {
		let label = UILabel()
		label.text = "Lowest Ask:"
		return label
	}()
	let lowestAskNumberLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	let highestBidLabel: UILabel = {
		let label = UILabel()
		label.text = "Highest Bid:"
		return label
	}()
	let highestBidNumberLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	let baseVolumeLabel: UILabel = {
		let label = UILabel()
		label.text = "Base Volume:"
		return label
	}()
	let baseVolumeNumberLabel: UILabel = {
		let label = UILabel()
		return label
	}()

	let quoteVolumeLabel: UILabel = {
		let label = UILabel()
		label.text = "Quote Volume:"
		return label
	}()
	let quoteVolumeNumberLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	var high24hr: UILabel = {
		let label = UILabel()
		label.text = "24Hr High:"
		return label
	}()
	var high24hrNumberLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	var low24hr: UILabel = {
		let label = UILabel()
		label.text = "24Hr Low:"
		return label
	}()
	var low24hrNumberLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	// MARK: - Initialization
	
	let ticker: Ticker
	
	init(title: String, ticker: Ticker) {
		self.ticker = ticker
		super.init(nibName: nil, bundle: nil)
		self.title = title
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycle

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		configureUI()
		
		setValues()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.leftPrimaryView.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
		self.rightPrimaryView.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
		self.informationView.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
	}
	
	func configureUI() {
		
		self.view.backgroundColor = projectColors.mainColor
		
		self.view.sv(self.chartView, self.timeRangeSegmentedControl, self.lineSegmentedControl,
		             self.leftPrimaryView, self.rightPrimaryView, self.informationView)
		self.view.layout(
			self.navigationController!.navigationBar.frame.height + 30,
			|-lineSegmentedControl.height(>=25).height(<=40)-|,
			10,
			|-chartView.height(>=100).height(<=300)-|,
			10,
			|-timeRangeSegmentedControl.height(>=25).height(<=40)-|,
			10,
			|-self.leftPrimaryView.width(100).height(50)-10-self.rightPrimaryView.height(50)-|,
			10,
			|-self.informationView-|,
			>=10
		)
		equalHeights([lineSegmentedControl, timeRangeSegmentedControl])
		
		// Left Primary View
		self.leftPrimaryView.sv(self.percentageChangeLabel)
		self.leftPrimaryView.layout(
			self.percentageChangeLabel.centerVertically().centerHorizontally()
		)
		
		// Right Primary View
		
		self.rightPrimaryView.sv(self.lastValueLabel)
		self.rightPrimaryView.layout(
			0,
			|-(>=10)-self.lastValueLabel-(>=10)-|,
			0
		)
		lastValueLabel.centerVertically().centerHorizontally()
		
		// Information View
		
		let verticalSpaceBetween: CGFloat = 10.0
		
		let leftView = UIView()
		leftView.backgroundColor = UIColor.clear
		
		let rightView = UIView()
		rightView.backgroundColor = UIColor.clear
		
		self.informationView.sv(leftView, rightView)
		self.informationView.layout(
			0,
			|leftView-rightView|,
			0
		)
		equalWidths([leftView, rightView])
		equalHeights([leftView, rightView])
		
		leftView.sv(self.low24hr, self.high24hr, self.lowestAskLabel, self.highestBidLabel, self.baseVolumeLabel, self.quoteVolumeLabel)
		leftView.layout(
			10,
			|-(>=10)-self.low24hr-|,
			verticalSpaceBetween,
			|-(>=10)-self.high24hr-|,
			verticalSpaceBetween,
			|-(>=10)-self.lowestAskLabel-|,
			verticalSpaceBetween,
			|-(>=10)-self.highestBidLabel-|,
			verticalSpaceBetween,
			|-(>=10)-self.baseVolumeLabel-|,
			verticalSpaceBetween,
			|-(>=10)-self.quoteVolumeLabel-|,
			10
		)
		
		rightView.sv(self.low24hrNumberLabel, self.high24hrNumberLabel, self.lowestAskNumberLabel, self.highestBidNumberLabel,
		             self.baseVolumeNumberLabel, self.quoteVolumeNumberLabel)
		rightView.layout(
			10,
			|-self.low24hrNumberLabel-(>=10)-|,
			verticalSpaceBetween,
			|-self.high24hrNumberLabel-(>=10)-|,
			verticalSpaceBetween,
			|-self.lowestAskNumberLabel-(>=10)-|,
			verticalSpaceBetween,
			|-self.highestBidNumberLabel-(>=10)-|,
			verticalSpaceBetween,
			|-self.baseVolumeNumberLabel-(>=10)-|,
			verticalSpaceBetween,
			|-self.quoteVolumeNumberLabel-(>=10)-|,
			10
		)
		
	}
	
	func setValues() {
		
		// Percent Change Label
		
		if ticker.percentChange == 0.0 {
			self.leftPrimaryView.backgroundColor = UIColor.flatGray()
			self.percentageChangeLabel.text = "\(ticker.percentChange.string(fractionDigits: 2))%"
		} else if ticker.percentChange < 0.0 {
			self.leftPrimaryView.backgroundColor = UIColor.flatRed()
			self.percentageChangeLabel.text = "\(ticker.percentChange.string(fractionDigits: 2))%"
		} else {
			self.leftPrimaryView.backgroundColor = UIColor.flatGreen()
			self.percentageChangeLabel.text = "+\(ticker.percentChange.string(fractionDigits: 2))%"
		}
		
		// Last Value Label
		
		self.lastValueLabel.text = "Last Value:" + ticker.last.string(fractionDigits: 10)
		
		// Information View Labels
		
		self.low24hrNumberLabel.text = ticker.low24hr.string(fractionDigits: 9)
		self.high24hrNumberLabel.text = ticker.high24hr.string(fractionDigits: 9)
		
		self.lowestAskNumberLabel.text = ticker.lowestAsk.string(fractionDigits: 9)
		self.highestBidNumberLabel.text = ticker.highestBid.string(fractionDigits: 9)
		
		self.baseVolumeNumberLabel.text = ticker.baseVolume.string(fractionDigits: 2)
		self.quoteVolumeNumberLabel.text = ticker.quoteVolume.string(fractionDigits: 2)
		
	}

}

enum TimeRangeSegmentedControlItem: Int {
	
	case day = 0, week, month, year, all
	
	func toString() -> String {
		switch self {
		case .day:
			return "Today"
		case .week:
			return "Week"
		case .month:
			return "Month"
		case .year:
			return "Year"
		case .all:
			return "All"
		}
	}
}

enum LineSegmentedControlItem: Int {
	
	case open = 0, close, low, high
	
	func toString() -> String {
		switch self {
		case .open:
			return "Open"
		case .close:
			return "Close"
		case .low:
			return "Low"
		case .high:
			return "High"
		}
	}
}
