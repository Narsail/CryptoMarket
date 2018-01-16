//
//  PortfolioItemCell.swift
//  CryptoMarket
//
//  Created by David Moeller on 30.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import Stevia
import IGListKit
import ChameleonFramework

protocol PortfolioItemDelegate: class {
    func deleteItem(crypto: OwningCryptoCurrency)
}

class PortfolioItemCell: CellWithRoundBorders {
    
    let amountLabel: UILabel = {
        let label = UILabel()
        
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 20)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        
        return label
    }()
    let symbolLabel: UILabel = {
        let label = UILabel()
        
        label.text = "BTC"
        label.font = UIFont.systemFont(ofSize: 20)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        
        return label
    }()
    let dollarLabel: UILabel = {
        let label = UILabel()
        
        label.text = "USD"
        label.font = UIFont.systemFont(ofSize: 20)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        label.textColor = Color.logoLightBlue.asUIColor
        
        return label
    }()
    
    let deleteButton = UIButton()
    
    var crypto: OwningCryptoCurrency?
    weak var delegate: PortfolioItemDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    func setupLayout() {

        self.sv(amountLabel, symbolLabel, deleteButton, dollarLabel)
        
        self.deleteButton.setBackgroundImage(#imageLiteral(resourceName: "rounded-remove-button"), for: .normal)
        self.deleteButton.addTarget(self, action: #selector(tappedDelete), for: .touchUpInside)
        
        self.backgroundColor = UIColor.flatWhite
        
        self.showDelete(show: false)
        
        self.layout(
            |-amountLabel-10-symbolLabel-dollarLabel-deleteButton.width(25)-20-|
        )

        deleteButton.centerVertically()
        amountLabel.centerVertically()
        symbolLabel.centerVertically()
        dollarLabel.centerVertically()
        
        amountLabel.Width == symbolLabel.Width
        dollarLabel.Width == amountLabel.Width * 2
        deleteButton.Width == deleteButton.Height
    }
    
    func set(crypto: OwningCryptoCurrency) {
        
        self.crypto = crypto

        self.amountLabel.text = crypto.amount.string(fractionDigits: 5)
        self.symbolLabel.text = crypto.symbol
        self.dollarLabel.text = "\((crypto.dollarValue ?? 0).string(fractionDigits: 2)) $"
        
    }
    
    func showDelete(show: Bool) {
        self.deleteButton.isHidden = !show
    }
    
    @objc func tappedDelete() {
        if let crypto = self.crypto {
            self.delegate?.deleteItem(crypto: crypto)
        }
    }
}
