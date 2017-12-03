//
//  PortfolioAmountSectionController.swift
//  CryptoMarket
//
//  Created by David Moeller on 28.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit
import Crashlytics

class PortfolioAmountSectionController: ListSectionController {
    
    var portfolioAmount: PortfolioAmount?
    
    override init() {
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
            of: PortfolioCell.self, for: self, at: index
            ) as? PortfolioCell else { return UICollectionViewCell() }
        
        if let amount = self.portfolioAmount {
            cell.set(portfolioAmount: amount)
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        
        portfolioAmount = object as? PortfolioAmount
        
    }
    
    override func didSelectItem(at index: Int) {
        Answers.logCustomEvent(withName: "Clicked on Portfolio Amount.", customAttributes: nil)
    }
    
}
