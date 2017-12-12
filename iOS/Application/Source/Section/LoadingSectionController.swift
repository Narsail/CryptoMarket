//
//  LoadingSectionController.swift
//  CryptoMarket
//
//  Created by David Moeller on 11.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit

class LoadingSectionController: ListSectionController {
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 55)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: LoadingCell.self, for: self, at: index
            ) as? LoadingCell else { return UICollectionViewCell() }
        
        return cell
    }
    
}
