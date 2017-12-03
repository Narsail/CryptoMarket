//
//  MarketDetailViewModel.swift
//  CryptoMarket
//
//  Created by David Moeller on 26.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import RxSwift
import Siesta

class MarketDetailViewModel: RxSwiftViewModel {
    
    let name: String
    let marketResource: Resource
    
    // MARK: - Inputs
    let reload = PublishSubject<Void>()
    
    // MARK: - Outputs
    let marketUpdated = PublishSubject<CryptoCurrencyExtended>()
    
    init(marketID: String, name: String) {
        
        self.name = name
        marketResource = CoinMarketCapAPI.shared.market(marketID)
        
        super.init()
            
        marketResource.addObserver(owner: self, closure: { [weak self] resource, _ in
            
            let markets: [CryptoCurrencyExtended]? = resource.typedContent()
            
            if let market: CryptoCurrencyExtended = markets?.first {
                self?.marketUpdated.onNext(market)
            }
            
        })
        
        // If Reload is triggered - load a new Resource
        reload.subscribe(onNext: { self.marketResource.load() }).disposed(by: self.disposeBag)
        
    }
    
}
