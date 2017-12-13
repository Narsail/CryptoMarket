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
    let historyDataResource: Resource
    
    // MARK: - Inputs
    let reload = PublishSubject<Void>()
    
    // MARK: - Outputs
    let marketUpdated = PublishSubject<CryptoCurrencyExtended>()
    let historyDataUpdated = PublishSubject<HistoDayResponse>()
    
    init(currency: Cryptocurrency) {
        
        self.name = currency.name
        marketResource = CoinMarketCapAPI.shared.market(currency.ident)
        historyDataResource = CryptoCompareAPI.shared.historicalData(fromSymbol: currency.symbol, toSymbol: "USD",
                                                                     exchange: "CCCAGG")
        
        super.init()
            
        marketResource.addObserver(owner: self, closure: { [weak self] resource, _ in
            
            let markets: [CryptoCurrencyExtended]? = resource.typedContent()
            
            if let market: CryptoCurrencyExtended = markets?.first {
                self?.marketUpdated.onNext(market)
            }
            
        })
        
        historyDataResource.addObserver(owner: self) { [weak self] resource, _ in
            
            if let data: HistoDayResponse = resource.typedContent() {
                self?.historyDataUpdated.onNext(data)
            }
            
        }
        
        // If Reload is triggered - load a new Resource
        reload.subscribe(onNext: { _ in
            self.marketResource.load()
            self.historyDataResource.load()
        }).disposed(by: self.disposeBag)
        
    }
    
}
