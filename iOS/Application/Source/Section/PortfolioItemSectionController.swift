//
//  PortfolioItemSectionController.swift
//  CryptoMarket
//
//  Created by David Moeller on 30.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit

class PortfolioItemSectionController: ListSectionController {
    
    var ownCrypto: OwningCryptoCurrency?
    weak var delegate: PortfolioItemDelegate?

    let showDelete: Bool
    
    init(showDelete: Bool) {
        self.showDelete = showDelete
        super.init()
        inset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width-20, height: 60)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(
            of: PortfolioItemCell.self, for: self, at: index
            ) as? PortfolioItemCell else { return UICollectionViewCell() }
        
        if let crypto = self.ownCrypto {
            cell.set(crypto: crypto)
        }
        
        cell.delegate = self.delegate
        cell.showDelete(show: showDelete)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        
        ownCrypto = object as? OwningCryptoCurrency
        
    }
    
    override func didSelectItem(at index: Int) {}
    
}
