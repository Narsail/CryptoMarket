//
//  SortSectionController.swift
//  CryptoMarket
//
//  Created by David Moeller on 03.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit

//protocol AddToPortfolioSelectionControllerDelegate: class {
//    func didSelectAddItem()
//}

class SortSectionController: ListSectionController {
    
    weak var delegate: SortCellDelegate?
    let order: SortOptions
    
//    init(delegate: AddToPortfolioSelectionControllerDelegate) {
    init(order: SortOptions, delegate: SortCellDelegate) {
        self.order = order
        super.init()
        inset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        self.delegate = delegate
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width - 20, height: 200)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        
        guard let cell = collectionContext?.dequeueReusableCell(
            of: SortCell.self, for: self, at: index
            ) as? SortCell else { return UICollectionViewCell() }
        
        cell.setOrder(order: self.order)
        cell.delegate = delegate
        
        return cell
    }
    
    override func didUpdate(to object: Any) {}
    
}
