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
        
        self.deleteButton.setBackgroundImage(#imageLiteral(resourceName: "rounded-remove-button"), for: .normal)
        self.deleteButton.addTarget(self, action: #selector(tappedDelete), for: .touchUpInside)
        self.showDelete(show: false)
        
        self.backgroundColor = UIColor.flatWhite
        
        let middleView = UIView()
        
        self.sv(amountLabel, middleView, symbolLabel, deleteButton)
        self.layout(
            |-amountLabel-middleView.width(1).centerVertically()-symbolLabel-|
        )
        self.layout(deleteButton.centerVertically().width(25)-20-|)
        
        amountLabel.Width == symbolLabel.Width
        deleteButton.Width == deleteButton.Height
    }
    
    func set(crypto: OwningCryptoCurrency) {
        
        self.crypto = crypto

        self.amountLabel.text = crypto.amount.string(fractionDigits: 5)
        self.symbolLabel.text = crypto.symbol
        
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
