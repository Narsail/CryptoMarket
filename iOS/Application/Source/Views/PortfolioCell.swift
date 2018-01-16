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
    
    let portfolioLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Portfolio: "
        label.font = UIFont.systemFont(ofSize: 20)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        
        return label
    }()
    
    let moneyLabel: UILabel = {
        let label = UILabel()

        label.text = "10000 USD"
        label.font = UIFont.systemFont(ofSize: 20)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right

        return label
    }()
    
//    let usdLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "10000 USD"
//        label.font = UIFont.systemFont(ofSize: 25)
//        label.minimumScaleFactor = 0.5
//        label.adjustsFontSizeToFitWidth = true
//        label.textAlignment = .center
//
//        return label
//    }()
//    let btcLabel: UILabel = {
//        let label = UILabel()
//
//        label.text = "1 BTC"
//        label.font = UIFont.systemFont(ofSize: 25)
//        label.minimumScaleFactor = 0.5
//        label.adjustsFontSizeToFitWidth = true
//        label.textAlignment = .centert
//
//        return label
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        self.backgroundColor = Color.lightCell.asUIColor
        
        let middleView = UIView()
        
        self.sv(portfolioLabel, middleView, moneyLabel)
        self.layout(
            |-20-portfolioLabel.centerVertically()-moneyLabel.centerVertically()-20-|
        )
//        usdLabel.Width == btcLabel.Width
    }
    
    func set(portfolioAmount: PortfolioAmount) {
        
        self.moneyLabel.text = "\(portfolioAmount.usd.string(fractionDigits: 2)) $ " + "(" +
            "\(portfolioAmount.btc.string(fractionDigits: 2)) \u{20BF}" + ")"
        
    }
}
