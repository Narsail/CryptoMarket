//
//  Colors.swift
//  CryptoMarket
//
//  Created by David Moeller on 28/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import UIKit
import Chameleon


struct ProjectColor {
	
	let mainColor: UIColor
	let mainColorDark: UIColor
	
	let mainComplementColor: UIColor
	let mainComplementColorDark: UIColor
	
	let mainContrastColor: UIColor
	let mainContrastColorDark: UIColor
	
	init(mainColor: UIColor, mainColorDark: UIColor) {
		self.mainColor = mainColor
		self.mainColorDark = mainColorDark
		
		self.mainComplementColor = UIColor.init(complementaryFlatColorOf: self.mainColor)
		self.mainComplementColorDark = UIColor.init(complementaryFlatColorOf: self.mainColorDark)
		
		self.mainContrastColor = UIColor.init(contrastingBlackOrWhiteColorOn: self.mainColor, isFlat: true)
		self.mainContrastColorDark = UIColor.init(contrastingBlackOrWhiteColorOn: self.mainColorDark, isFlat: true)
	}
	
	var navigationBarColor: UIColor {
		return self.mainColorDark
	}
	
	// MARK: Segmented Control Color
	
	var segmentedControlBackgroundColor: UIColor {
		return UIColor.white
	}
	
	var segmentedControlIndicatorColor: UIColor {
		return self.mainColor
	}
	
	var segmentedTitleColor: UIColor {
		return UIColor.black
	}
	
	var segmentedSelectedTitleColor: UIColor {
		return UIColor.black
	}
	
	// MARK: Line Chart Colors
	
	var lineColor: UIColor {
		return self.mainContrastColor
	}
	
}
