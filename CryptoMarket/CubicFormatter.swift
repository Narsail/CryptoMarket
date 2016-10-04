//
//  CubicFormatter.swift
//  CryptoMarket
//
//  Created by David Moeller on 03/10/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import Charts

class CubicFillFormatter: IFillFormatter {
	
	func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
		return -10.0
	}
	
}
