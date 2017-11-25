//
//  AppointmentListViewModel.swift
//  SmartNetworkung
//
//  Created by David Moeller on 13.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift
import Siesta

class MarketListViewModel {
    
    let disposeBag = DisposeBag()
    
    let adapterDataSource: MarketListAdapterDataSource
    let coinMarketCapAPI = CoinMarketCapAPI.shared
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    let contentUpdated = PublishSubject<Void>()
    
    init() {
        
        let overlay = ResourceStatusOverlay()
        
        self.adapterDataSource = MarketListAdapterDataSource(overlay: overlay)
        
        coinMarketCapAPI.markets.addObserver(owner: self, closure: { [weak self] resource, _ in
            
            if let markets: [Market] = resource.typedContent() {
            
                self?.adapterDataSource.markets = markets
                
            }
            
            self?.contentUpdated.onNext(())
            
        }).addObserver(overlay)
        
        self.reloadData()
        
    }
    
    func reloadData() {
        coinMarketCapAPI.markets.load()
    }
    
}

class MarketListAdapterDataSource: NSObject {
    
    var markets: [Market] = []
    let overlay: ResourceStatusOverlay
    
    init(overlay: ResourceStatusOverlay) {
        self.overlay = overlay
        super.init()
    }
    
}

extension MarketListAdapterDataSource: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        if markets.isEmpty {
            return []
        }
        
        return ["Cryptos" as NSString] + markets
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case is NSString:
            return TitleSectionController()
        default:
            return MarketSectionController()
        }

    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return overlay
    }
    
}
