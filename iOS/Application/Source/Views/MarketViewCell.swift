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

class MarketViewCell: CellWithRoundBorders {
	
	// MARK: - Top View
	var topView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.clear
		return view
	}()
	
	// MARK: Left View
	var topLeftView: UIView = {
		let view = UIView()
        view.backgroundColor = UIColor.flatWhite
		return view
	}()
	
	var differenceLabel: UILabel = {
		let label = UILabel()
        label.style(Labels.body)
		label.textColor = UIColor.black
        label.textAlignment = .center
		return label
	}()
	
	// MARK: Right View
	var topRightView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.flatGray
		return view
	}()
	
	var marketUILabel: UILabel = {
		let label = UILabel()
        label.style(Labels.bodyMedium)
		label.textColor = UIColor.black
        label.textAlignment = .left
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
        label.style(Labels.body)
		label.text = "USD"
        label.textAlignment = .left
		return label
	}()
	var marketCapUSD: UILabel = {
		let label = UILabel()
        label.style(Labels.body)
        label.text = "USD"
        label.textAlignment = .left
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
			0,
			|topView|,
			|bottomView|,
			0
		)
        topView.Height == bottomView.Height
		
		// Top View Sub Views
		topView.sv(topLeftView, topRightView)
		topView.layout(
			0,
			|topLeftView-0-topRightView.width(100)|,
			0
		)
		equalHeights(topLeftView, topRightView)
		
		topLeftView.sv(marketUILabel)
		topLeftView.layout(
			|-20-marketUILabel.centerVertically(2.5)-|
		)
		
		topRightView.sv(differenceLabel)
		topRightView.layout(
            |-differenceLabel.centerVertically()-|
		)
		
		// Add Information Views
		
		bottomView.sv(priceUSD, marketCapUSD)
		bottomView.layout(
            0,
			|-20-priceUSD.centerVertically()-10-marketCapUSD.centerVertically()-|,
            0
		)
        priceUSD.Width == marketCapUSD.Width * 0.9
		
	}
	
    func initializeWith(_ market: Cryptocurrency?) {
        
        guard let market = market else { return }
        
        self.marketUILabel.text = market.name
        
        self.priceUSD.text = market.priceUSD ?? "0" + " USD"
        self.marketCapUSD.text = "Cap: " + market.formattedMarketCap
        
        if let percentChange24 = market.percentChange24hAmount {
            if percentChange24 == 0.0 {
                self.topRightView.backgroundColor = UIColor.flatGray
                self.differenceLabel.text = "\(percentChange24.string(fractionDigits: 2))%"
            } else if percentChange24 < 0.0 {
                self.topRightView.backgroundColor = UIColor.flatRed
                self.differenceLabel.text = "\(percentChange24.string(fractionDigits: 2))%"
            } else {
                self.topRightView.backgroundColor = UIColor.flatGreen
                self.differenceLabel.text = "+\(percentChange24.string(fractionDigits: 2))%"
            }
        } else {
            self.topRightView.backgroundColor = UIColor.flatGray
            self.differenceLabel.text = "\(0.00)%"
        }
        
    }
	
}

extension Double {
	func string(fractionDigits: Int) -> String {
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
    func string(fractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = fractionDigits
        if self > 1 {
            formatter.maximumFractionDigits = 2
        }
        return formatter.string(for: self)!
    }
}
