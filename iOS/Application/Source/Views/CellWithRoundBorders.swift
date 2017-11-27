//
//  CellWithRoundBorders.swift
//  CryptoMarket
//
//  Created by David Moeller on 27.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import UIKit

class CellWithRoundBorders: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureRoundBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureRoundBorder()
    }
    
    func configureRoundBorder() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
}
