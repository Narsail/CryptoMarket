//
//  SortingProvider.swift
//  CryptoMarket
//
//  Created by David Moeller on 31.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import CollectionKit

class SortingProvider: CollectionProvider<(SortCellDelegate, SortOptions), SortCell> {
    
    let bodyInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    let cellHeight: CGFloat = 200
    
    init() {
        
        super.init(
            data: [],
            viewUpdater: { (cell: SortCell, data: (SortCellDelegate, SortOptions), index: Int) in
                cell.delegate = data.0
                cell.setOrder(order: data.1)
            },
            layout: FixedViewLayout(cellHeight: cellHeight).inset(by: bodyInset)
        )
        
    }
    
    func display(with delegate: SortCellDelegate, and options: SortOptions) {
        if let provider = self.dataProvider as? ArrayDataProvider<(SortCellDelegate, SortOptions)> {
            provider.data = [(delegate, options)]
        }
    }
    
    func hide() {
        if let provider = self.dataProvider as? ArrayDataProvider<(SortCellDelegate, SortOptions)> {
            provider.data = []
        }
    }
    
}
