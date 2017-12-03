//
//  AddToPortfolioSectionController.swift
//  CryptoMarket
//
//  Created by David Moeller on 30.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit

protocol AddToPortfolioSelectionControllerDelegate: class {
    func didSelectAddItem()
}

class AddToPortfolioSectionController: ListSectionController {
    
    weak var delegate: AddToPortfolioSelectionControllerDelegate?
    
    init(delegate: AddToPortfolioSelectionControllerDelegate) {
        super.init()
        inset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        self.delegate = delegate
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 40)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(
            of: AddCell.self, for: self, at: index
            ) as? AddCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {}
    
    override func didSelectItem(at index: Int) {
        delegate?.didSelectAddItem()
    }
    
}
