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
	
	// Top Hierarchy Views
	var leftView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.flatGray()
		return view
	}()
	var rightView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.clear
		return view
	}()
	
	var rightTopView: UIView = {
		let view = UIView()
		view.backgroundColor = projectColors.mainComplementColor
		return view
	}()
	var rightMiddleView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.white
		return view
	}()
	
	
	// Information Views
	
	var marketUILabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.white
		return label
	}()
	var lastValueUILabel: UILabel = {
		let label = UILabel()
		return label
	}()
	var favoriteItem: UIButton = {
		let button = UIButton(type: .custom)
		button.backgroundColor = UIColor.white
		button.setImage(UIImage(named: "UnselectedBookmark"), for: .normal)
		button.setImage(UIImage(named: "SelectedBookmark"), for: .selected)
		return button
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
		
		let topViewHeight: CGFloat = 35
		let middleViewHeight: CGFloat = 60
		
		// Add Top Hierarchy Views
		
		sv(leftView, rightView)
		layout(
			5,
			|-10-leftView.width(15).height(topViewHeight + middleViewHeight),
			5
		)
		layout(
			5,
			leftView-0-rightView-10-|,
			5
		)
		
		// Add to Right View
		rightView.sv(rightTopView, rightMiddleView)
		rightView.layout(
			0,
			|rightTopView.height(topViewHeight)|,
			|rightMiddleView.height(middleViewHeight)|,
			0
		)
		
		// Add Information Views
		
		rightTopView.sv(marketUILabel)
		rightTopView.layout(
			marketUILabel.centerVertically().centerHorizontally()
		)
		
		rightMiddleView.sv(lastValueUILabel, favoriteItem)
		rightMiddleView.layout(
			favoriteItem.centerVertically().height(30).width(30)-|
		)
		rightMiddleView.layout(
			|-lastValueUILabel.centerVertically()
		)
		
		// Add Actions
		favoriteItem.addTarget(self, action: #selector(TickerTableViewCell.setFavorite), for: .touchUpInside)
		
	}
	
	func initialize(withTicker ticker: Ticker) {
		self.marketUILabel.text = "Market: \(ticker.market?.label ?? "Unknown")"
		self.lastValueUILabel.text = ticker.last.format(f: "9")
		self.id = ticker.id
		
		favoriteItem.isSelected = ticker.favorite
		
		if ticker.last == ticker.priorLast {
			self.leftView.backgroundColor = UIColor.flatGray()
		} else if ticker.last < ticker.priorLast {
			self.leftView.backgroundColor = UIColor.flatRed()
		} else {
			self.leftView.backgroundColor = UIColor.flatGreen()
		}
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		rightTopView.round(corners: [UIRectCorner.topRight], radius: 10)
		rightMiddleView.round(corners: [.bottomRight], radius: 10)
		leftView.round(corners: [.topLeft, .bottomLeft], radius: 10)
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
	func format(f: String) -> String {
		return String(format: "%\(f)f", self)
	}
}
