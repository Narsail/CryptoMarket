//
//  AddCell.swift
//  CryptoMarket
//
//  Created by David Moeller on 30.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import Stevia
import IGListKit

class AddCell: UICollectionViewCell {
    
    let button = UIButton(type: UIButtonType.contactAdd)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        button.tintColor = UIColor.flatGrayDark
        button.isUserInteractionEnabled = false
        
        self.sv(
            button
        )
        self.layout(
            button.centerVertically().centerHorizontally()
        )
    }
}
