//
//  MarketSectionController.swift
//  CryptoMarket
//
//  Created by David Moeller on 25.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit

class MarketSectionController: ListSectionController {
    
    var market: Market?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 80)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(
            of: MarketViewCell.self, for: self, at: index
            ) as? MarketViewCell else { return UICollectionViewCell() }
        
        cell.initializeWith(self.market)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.market = object as? Market
    }
    
    override func didSelectItem(at index: Int) {}
    
}
