//
//  DateValueFormatter.swift
//  CryptoMarket
//
//  Created by David Moeller on 03/10/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import Charts
import DateHelper


class DateValueFormatter: NSObject, IAxisValueFormatter {
	
	func stringForValue(_ value: Double, axis: AxisBase?) -> String {
		
		let date = Date(timeIntervalSince1970: value)
		
		return date.toString()
		
	}
	
}

class DayValueFormatter: NSObject, IAxisValueFormatter {
	
	func stringForValue(_ value: Double, axis: AxisBase?) -> String {
		
		let date = Date(timeIntervalSince1970: value)
		
		return date.toString(.custom("HH:mm:ss"))
		
	}
	
}
