//
//  PortfolioCell.swift
//  CryptoMarket
//
//  Created by David Moeller on 28.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import Stevia
import IGListKit
import ChameleonFramework

class PortfolioCell: CellWithRoundBorders {
    
    let usdLabel: UILabel = {
        let label = UILabel()
        
        label.text = "10000 USD"
        label.font = UIFont.systemFont(ofSize: 25)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        return label
    }()
    let btcLabel: UILabel = {
        let label = UILabel()
        
        label.text = "1 BTC"
        label.font = UIFont.systemFont(ofSize: 25)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        self.backgroundColor = UIColor.flatWhite
        
        let middleView = UIView()
        
        self.sv(usdLabel, middleView, btcLabel)
        self.layout(
            |-usdLabel-middleView.width(1).centerVertically()-btcLabel-|
        )
        usdLabel.Width == btcLabel.Width
    }
    
    func set(portfolioAmount: PortfolioAmount) {
        
        self.usdLabel.text = "\(portfolioAmount.usd.string(fractionDigits: 2)) $"
        self.btcLabel.text = "\(portfolioAmount.btc.string(fractionDigits: 2)) \u{20BF}"
        
    }
}
