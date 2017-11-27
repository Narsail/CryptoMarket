//
//  GlobalSectionController.swift
//  CryptoMarket
//
//  Created by David Moeller on 27.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit

class GlobalSectionController: ListSectionController {
    
    var global: Global?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width - 20, height: 140)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(
            of: GlobalViewCell.self, for: self, at: index
            ) as? GlobalViewCell else { return UICollectionViewCell() }
        
        cell.initializeWith(self.global)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.global = object as? Global
    }
    
}
