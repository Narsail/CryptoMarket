//
//  CoinProvider.swift
//  CryptoMarket
//
//  Created by David Moeller on 01.01.18.
//  Copyright © 2018 David Moeller. All rights reserved.
//

import Foundation
import CollectionKit

class CoinProvider: CollectionProvider<Cryptocurrency, MarketViewCell> {

    let bodyInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    let cellHeight: CGFloat = 70
    
    init() {
        
        super.init(
            data: [],
            viewUpdater: { (cell: MarketViewCell, data: Cryptocurrency, index: Int) in
                cell.initializeWith(data)
            },
            layout: FixedViewLayout(cellHeight: cellHeight).inset(by: bodyInset)
        )
        
    }
    
    func set(_ data: [Cryptocurrency]) {
        if let provider = self.dataProvider as? ArrayDataProvider<Cryptocurrency> {
            provider.data = data
        }
    }
    
}

class FixedViewLayout<Data>: CollectionLayout<Data> {
    
    let cellHeight: CGFloat
    
    var spacing: CGFloat = 10
    var collectionWidth: CGFloat = 0
    var numberOfItems: Int = 0
    
    init(cellHeight: CGFloat) {
        self.cellHeight = cellHeight
        super.init()
    }
    
    public override func layout(collectionSize: CGSize,
                                dataProvider: CollectionDataProvider<Data>,
                                sizeProvider: @escaping (Int, Data, CGSize) -> CGSize) {
        // store the following information necessary when calculating cell frame and contentSize
        numberOfItems = dataProvider.numberOfItems
        collectionWidth = collectionSize.width
    }
    
    public final override var contentSize: CGSize {
        return CGSize(width: collectionWidth,
                      height: CGFloat(numberOfItems) * (cellHeight + spacing) - spacing)
    }
    
    public final override func frame(at: Int) -> CGRect {
        return CGRect(x: 0, y: CGFloat(at) * (cellHeight + spacing),
                      width: collectionWidth, height: cellHeight)
    }
    
    public override func visibleIndexes(activeFrame: CGRect) -> [Int] {
        let minIndex = Int(activeFrame.minY / (cellHeight + spacing))
        let maxIndex = Int(activeFrame.maxY / (cellHeight + spacing))
        return Array(minIndex...maxIndex)
    }
    
}
