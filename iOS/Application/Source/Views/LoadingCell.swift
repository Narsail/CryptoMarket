//
//  LoadingCell.swift
//  CryptoMarket
//
//  Created by David Moeller on 11.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import UIKit
import Stevia
import IGListKit

class LoadingCell: UICollectionViewCell {
    
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    func setupLayout() {
        self.sv(
            loadingIndicator
        )
        self.layout(
            loadingIndicator.centerVertically().centerHorizontally()
        )
        
        loadingIndicator.startAnimating()
    }
}
