//
//  GlobalCell.swift
//  CryptoMarket
//
//  Created by David Moeller on 27.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import UIKit
import Stevia
import ChameleonFramework

class GlobalViewCell: CellWithRoundBorders {
    
    // MARK: - Top View
    var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatWhite
        return view
    }()
    
    let titleLabel = UILabel()
    let marketCapLabel = UILabel()
    
    // MARK: - Bottom View
    
    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatWhite
        return view
    }()
    
    // Information Views
    
    let volumeLabel = UILabel()
    let bitcoinPercentageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureUI()
    }
    
    func configureUI() {
        
        self.backgroundColor = UIColor.flatWhite
        
        // Add Top Hierarchy Views
        
        sv(topView, bottomView)
        layout(
            5,
            |topView|,
            |bottomView|,
            5
        )
        topView.Height == bottomView.Height/3
        
        // Top View Sub Views
        topView.sv(titleLabel)
        topView.layout(
            0,
            |-20-titleLabel.centerVertically()-20-|,
            0
        )
        titleLabel.style(Labels.bodyMedium)
        titleLabel.textAlignment = .left
        
        // Add Information Views
        
        bottomView.sv(marketCapLabel, volumeLabel, bitcoinPercentageLabel)
        bottomView.layout(
            |-20-marketCapLabel-20-|,
            10,
            |-20-volumeLabel.centerVertically()-20-|,
            10,
            |-20-bitcoinPercentageLabel-20-|
        )
        marketCapLabel.style(Labels.body)
        volumeLabel.style(Labels.body)
        bitcoinPercentageLabel.style(Labels.body)
        
    }
    
    func initializeWith(_ global: Global?) {
        
        self.titleLabel.text = "Global Data"
        
        guard let global = global else { return }
        
        self.marketCapLabel.text = "Cap: " + global.formattedMarketCap
        self.volumeLabel.text = "Volume (24h): " + global.formattedVolume
        self.bitcoinPercentageLabel.text = "Bitcoin Share: " + "\(global.bitcoinPercentageOfMarketCap)" + "%"
        
    }

}
