//
//  TickerTableViewCell.swift
//  CryptoMarket
//
//  Created by David Moeller on 27/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import UIKit
import Stevia

class TickerTableViewCell: UITableViewCell {
	
	// MARK: - Top View
	var topView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.clear
		return view
	}()
	
	// MARK: Left View
	var topLeftView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.flatGray()
		return view
	}()
	
	var differenceLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.black
		return label
	}()
	
	// MARK: Right View
	var topRightView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		return view
	}()
	
	var marketUILabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.black
		label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize + 2)
		return label
	}()
	
	var favoriteItem: UIButton = {
		let button = UIButton(type: .custom)
		button.backgroundColor = UIColor.white
		button.setImage(UIImage(named: "UnselectedBookmark"), for: .normal)
		button.setImage(UIImage(named: "SelectedBookmark"), for: .selected)
		return button
	}()
	
	
	// MARK: - Bottom View
	
	var bottomView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		return view
	}()
	
	
	// Information Views
	
	var high24hr: UILabel = {
		let label = UILabel()
		label.text = "High:"
		return label
	}()
	var high24hrNumberLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	var low24hr: UILabel = {
		let label = UILabel()
		label.text = "Low:"
		return label
	}()
	var low24hrNumberLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	var volume: UILabel = {
		let label = UILabel()
		return label
	}()
	
	
	var id: Int = 0
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		configureUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func configureUI() {
		
		self.backgroundColor = UIColor.clear
		self.selectionStyle = .none
		
		let topViewHeight: CGFloat = 50
		let bottomViewHeight: CGFloat = 60
		
		// Add Top Hierarchy Views
		
		sv(topView, bottomView)
		layout(
			5,
			|-10-topView.height(topViewHeight)-10-|,
			|-10-bottomView.height(bottomViewHeight)-10-|,
			5
		)
		
		// Top View Sub Views
		topView.sv(topLeftView, topRightView)
		topView.layout(
			0,
			|topLeftView.width(100)-0-topRightView|,
			0
		)
		equalHeights(topLeftView, topRightView)
		
		topLeftView.sv(differenceLabel)
		topLeftView.layout(
			differenceLabel.centerVertically().centerHorizontally()
		)
		
		topRightView.sv(marketUILabel, favoriteItem)
		topRightView.layout(
			|-marketUILabel.centerVertically()-5-favoriteItem.centerVertically().height(30).width(30)-|
		)
		
		// Add Information Views
		
		bottomView.sv(high24hr, high24hrNumberLabel, low24hr, low24hrNumberLabel, volume)
		bottomView.layout(
			5,
			|-10-high24hr,
			|-10-low24hr,
			5
		)
		bottomView.layout(
			5,
			high24hr-5-high24hrNumberLabel
		)
		bottomView.layout(
			high24hr-5-low24hrNumberLabel
		)
		bottomView.layout(
			high24hr,
			low24hrNumberLabel,
			5
		)
		bottomView.layout(
			volume.centerVertically()-|
		)
		
		// Add Actions
		favoriteItem.addTarget(self, action: #selector(TickerTableViewCell.setFavorite), for: .touchUpInside)
		
	}
	
	func initialize(withTicker ticker: Ticker) {
		
		if let marketLabel = ticker.market?.label {
			let (firstAbbr, secondAbbr) = MarketAbbreviation.convertMarketName(marketName: marketLabel)
			self.marketUILabel.text = "\(firstAbbr) <-> \(secondAbbr)"
		} else {
			self.marketUILabel.text = "Market: Unknown"
		}
		
		self.high24hrNumberLabel.text = ticker.high24hr.string(fractionDigits: 9)
		self.low24hrNumberLabel.text = ticker.low24hr.string(fractionDigits: 9)
		self.volume.text = "Volume: " + ticker.baseVolume.string(fractionDigits: 2)
		
		self.id = ticker.id
		
		favoriteItem.isSelected = ticker.favorite
		
		if ticker.percentChange == 0.0 {
			self.topLeftView.backgroundColor = UIColor.flatGray()
			self.differenceLabel.text = "\(ticker.percentChange.string(fractionDigits: 2))%"
		} else if ticker.percentChange < 0.0 {
			self.topLeftView.backgroundColor = UIColor.flatRed()
			self.differenceLabel.text = "\(ticker.percentChange.string(fractionDigits: 2))%"
		} else {
			self.topLeftView.backgroundColor = UIColor.flatGreen()
			self.differenceLabel.text = "+\(ticker.percentChange.string(fractionDigits: 2))%"
		}
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		topView.round(corners: [UIRectCorner.topLeft ,UIRectCorner.topRight], radius: 10)
		bottomView.round(corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: 10)
	}
	
	func setFavorite() {
		Store.toggleTickerFavorite(withTickerID: self.id)
	}
	
}

extension UIView {
	
	/**
	Rounds the given set of corners to the specified radius
	
	- parameter corners: Corners to round
	- parameter radius:  Radius to round to
	*/
	func round(corners: UIRectCorner, radius: CGFloat) {
		_round(corners: corners, radius: radius)
	}
	
	/**
	Rounds the given set of corners to the specified radius with a border
	
	- parameter corners:     Corners to round
	- parameter radius:      Radius to round to
	- parameter borderColor: The border color
	- parameter borderWidth: The border width
	*/
	func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
		let mask = _round(corners: corners, radius: radius)
		addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
	}
	
	/**
	Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
	
	- parameter diameter:    The view's diameter
	- parameter borderColor: The border color
	- parameter borderWidth: The border width
	*/
	func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
		layer.masksToBounds = true
		layer.cornerRadius = diameter / 2
		layer.borderWidth = borderWidth
		layer.borderColor = borderColor.cgColor;
	}
	
}

private extension UIView {
	
	@discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
		let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.frame = self.bounds
		mask.path = path.cgPath
		self.layer.mask = mask
		return mask
	}
	
	func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
		let borderLayer = CAShapeLayer()
		borderLayer.path = mask.path
		borderLayer.fillColor = UIColor.clear.cgColor
		borderLayer.strokeColor = borderColor.cgColor
		borderLayer.lineWidth = borderWidth
		borderLayer.frame = bounds
		layer.addSublayer(borderLayer)
	}
	
}

extension Double {
	func string(fractionDigits:Int) -> String {
		let formatter = NumberFormatter()
		formatter.minimumIntegerDigits = 1
		formatter.maximumFractionDigits = fractionDigits
		if self > 1 {
			formatter.maximumFractionDigits = 2
		}
		return formatter.string(for: self)!
	}
}
