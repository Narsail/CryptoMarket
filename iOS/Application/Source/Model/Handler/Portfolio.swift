//
//  PortfolioCalculator.swift
//  CryptoMarket
//
//  Created by David Moeller on 28.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import RxSwift
import DefaultsKit
import IGListKit

typealias CryptoSymbol = String
typealias CryptoName = String

class Portfolio {
    
    private let listKey = "portfolioList"
    private let store = Defaults.shared
    
    static let shared = Portfolio()
    
    /* Reactive Components */
    // MARK: - Inputs
    let cryptoUpdate: AnyObserver<[Cryptocurrency]>
    var availableCryptos: [(CryptoName, CryptoSymbol)] = []
    
    // MARK: - Outputs
    var amountUpdated: Observable<PortfolioAmount?> = Observable.never()
    var updatedPortfolio = BehaviorSubject<[OwningCryptoCurrency]>(value: [])
    
    private init() {
        
        let _calulcate = PublishSubject<[Cryptocurrency]>()
        cryptoUpdate = _calulcate.asObserver()
        
        amountUpdated = _calulcate.asObservable().map { [weak self] cryptos in
            
            // Update the Available Cryptos?
            if self?.availableCryptos.isEmpty ?? true || (self?.availableCryptos.count) != cryptos.count {
                
                self?.availableCryptos = []
                
                for crypto in cryptos {
                    self?.availableCryptos.append((crypto.name, crypto.symbol))
                }
                
            }
            
            var amount: PortfolioAmount?
            
            // Get Portfolio Content
            let content = self?.getAll() ?? []
            
            for ownCrypto in content {
                
                // Get the corresponding Crypto Market Value
                if let index = cryptos.index(where: { $0.symbol == ownCrypto.symbol }) {
                    
                    let crypto = cryptos[index]
                    
                    let usd = crypto.priceUSDAsDouble * ownCrypto.amount
                    let btc = crypto.priceBTCAsDouble * ownCrypto.amount
                    
                    if amount != nil {
                        amount?.add(usd: usd, btc: btc)
                    } else {
                        amount = PortfolioAmount(usd: usd, btc: btc)
                    }
                    
                }

            }
            
            return amount
        }
        
        self.updatePortfolio()
        
        // Simuator
        if Environment.isSimulator {
            self.removeAll()
        }
        
    }
    
    func updatePortfolio() {
        self.updatedPortfolio.onNext(self.getAll())
    }
    
    func getAll() -> [OwningCryptoCurrency] {
        
        var portfolio = [OwningCryptoCurrency]()
        
        let list = self.getList()
        
        for ident in list {
            
            if let crypto = self.store.get(for: Key<OwningCryptoCurrency>(ident)) {
                portfolio.append(crypto)
            }
            
        }
        
        return portfolio
        
    }
    
    func add(_ currency: OwningCryptoCurrency) {

        // Add to List
        self.addToList(currency)
        
        // Add to the Store
        self.store.set(currency, for: Key<OwningCryptoCurrency>(currency.ident))
        
        // Update Portfolio
        self.updatePortfolio()
        
    }
    
    func remove(_ currency: OwningCryptoCurrency) {
        
        // Remove from Store
        self.store.clear(Key<OwningCryptoCurrency>(currency.ident))
        
        // Remove from list
        self.removeFromList(currency)
        
        // Update Portfolio
        self.updatePortfolio()
        
    }
    
    func removeAll() {
        
        let all = self.getAll()
        
        all.forEach { self.remove($0) }
        
    }
    
    private func getList() -> [String] {
        let key = Key<[String]>(self.listKey)
        return store.get(for: key) ?? []
    }
    
    private func setlist(list: [String]) {
        let key = Key<[String]>(self.listKey)
        store.set(list, for: key)
    }
    
    private func addToList(_ currency: OwningCryptoCurrency) {
        
        var list = self.getList()
        
        list.append(currency.ident)
        
        self.setlist(list: list)
    }
    
    private func removeFromList(_ currency: OwningCryptoCurrency) {
        
        var list = self.getList()
        
        if let index = list.index(of: currency.ident) {
            list.remove(at: index)
        }
        
        self.setlist(list: list)
        
    }
    
}

class PortfolioAmount: Codable {
    
    var usd: Double
    var btc: Double
    
    init(usd: Double, btc: Double) {
        self.usd = usd
        self.btc = btc
    }
    
    func add(usd: Double, btc: Double) {
        self.usd += usd
        self.btc += btc
    }
    
}

extension PortfolioAmount: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return ObjectIdentifier(self).hashValue as NSNumber
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? PortfolioAmount {
            return (usd, btc) == (object.usd, object.btc)
        }
        return false
    }
    
}
