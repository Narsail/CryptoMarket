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
		view.maxHighlightDistance = 300.0
		return view
	}()
	let segmentedControl: BetterSegmentedControl = {
		let control = BetterSegmentedControl(frame: CGRect(), titles: [SegmentedControlItem.day.toString(), SegmentedControlItem.week.toString(), SegmentedControlItem.month.toString(), SegmentedControlItem.year.toString(), SegmentedControlItem.all.toString()], index: 0, backgroundColor: projectColors.segmentedControlBackgroundColor, titleColor: projectColors.segmentedTitleColor, indicatorViewBackgroundColor: projectColors.segmentedControlIndicatorColor, selectedTitleColor: projectColors.segmentedSelectedTitleColor)
		return control
	}()

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		configureUI()
		
	}
	
	func configureUI() {
		
		self.view.backgroundColor = projectColors.mainColor
		
		self.view.sv(self.chartView, self.segmentedControl)
		self.view.layout(
			self.navigationController!.navigationBar.bounds.height + 10,
			|-chartView.height(300)-|,
			|-segmentedControl.height(50)-|
		)
		
	}

}

enum SegmentedControlItem: Int {
	
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
