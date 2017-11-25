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
import ChameleonFramework

class MarketViewCell: UICollectionViewCell {
	
	// MARK: - Top View
	var topView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.clear
		return view
	}()
	
	// MARK: Left View
	var topLeftView: UIView = {
		let view = UIView()
        view.backgroundColor = UIColor.flatGray
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
		view.backgroundColor = UIColor.flatWhite
		return view
	}()
	
	var marketUILabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.black
		label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize + 2)
        label.textAlignment = .center
		return label
	}()
	
	var favoriteItem: UIButton = {
		let button = UIButton(type: .custom)
		button.backgroundColor = UIColor.white
		button.setImage(UIImage(named: "UnselectedBookmark"), for: .normal)
		button.setImage(UIImage(named: "SelectedBookmark"), for: .selected)
        button.isHidden = true
		return button
	}()
		
	// MARK: - Bottom View
	
	var bottomView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.flatWhite
		return view
	}()

	// Information Views
	
	var priceUSD: UILabel = {
		let label = UILabel()
		label.text = "USD"
        label.textAlignment = .center
		return label
	}()
	var priceBTC: UILabel = {
		let label = UILabel()
        label.text = "BTC"
        label.textAlignment = .center
		return label
	}()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureUI()
    }
	
	func configureUI() {
		
		self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor.flatGray.cgColor
		
		// Add Top Hierarchy Views
		
		sv(topView, bottomView)
		layout(
			5,
			|-10-topView-10-|,
			|-10-bottomView-10-|,
			5
		)
        topView.Height == bottomView.Height
		
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
			|-marketUILabel.centerVertically().centerHorizontally()-|
		)
		
		// Add Information Views
		
		bottomView.sv(priceUSD, priceBTC)
		bottomView.layout(
            0,
			|-priceUSD.centerVertically()-priceBTC.centerVertically()-|,
            0
		)
        priceUSD.Width == priceBTC.Width
		
		// Add Actions
		// favoriteItem.addTarget(self, action: #selector(TickerTableViewCell.setFavorite), for: .touchUpInside)
		
	}
	
    func initializeWith(_ market: Market?) {
        
        guard let market = market else { return }
        
        self.marketUILabel.text = market.name
        
        self.priceUSD.text = market.priceUSD + " USD"
        self.priceBTC.text = market.priceBTC + " BTC"
        
//        self.high24hrNumberLabel.text = ticker.high24hr.string(fractionDigits: 9)
//        self.low24hrNumberLabel.text = ticker.low24hr.string(fractionDigits: 9)
//        self.volume.text = "Volume: " + ticker.baseVolume.string(fractionDigits: 2)
//
//        self.id = ticker.id
        
//        favoriteItem.isSelected = ticker.favorite
        
        guard let percentChange24 = market.percentChange24hAmount else { return }
        
        if percentChange24 == 0.0 {
            self.topLeftView.backgroundColor = UIColor.flatGray
            self.differenceLabel.text = "\(percentChange24.string(fractionDigits: 2))%"
        } else if percentChange24 < 0.0 {
            self.topLeftView.backgroundColor = UIColor.flatRed
            self.differenceLabel.text = "\(percentChange24.string(fractionDigits: 2))%"
        } else {
            self.topLeftView.backgroundColor = UIColor.flatGreen
            self.differenceLabel.text = "+\(percentChange24.string(fractionDigits: 2))%"
        }
        
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		topView.round(corners: [UIRectCorner.topLeft ,UIRectCorner.topRight], radius: 10)
		bottomView.round(corners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radius: 10)
	}
	
	func setFavorite() {
//        Store.toggleTickerFavorite(withTickerID: self.id)
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

extension Float {
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
