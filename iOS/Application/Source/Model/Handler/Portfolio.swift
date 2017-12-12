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
    private let store = Defaults(userDefaults: UserDefaults(suiteName: "group.crypto.portfolio")!)
    
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
        
        amountUpdated = _calulcate.asObservable().debounce(0.5, scheduler: MainScheduler.instance)
            .map { [weak self] cryptos in
            
                // Update the Available Cryptos?
                if self?.availableCryptos.isEmpty ?? true || (self?.availableCryptos.count) != cryptos.count {
                    
                    self?.availableCryptos = []
                    
                    for crypto in cryptos {
                        self?.availableCryptos.append((crypto.name, crypto.symbol))
                    }
                    
                }
                
                var amount: PortfolioAmount?
                
                // Get Portfolio Content
                var content: [OwningCryptoCurrency] = []
                
                if let store = self?.store, let all = self?.getAll(store: store) {
                    content = all
                }
                
                for ownCrypto in content {
                    
                    // Get the corresponding Crypto Market Value
                    if let index = cryptos.index(where: { $0.symbol == ownCrypto.symbol }) {
                        
                        let crypto = cryptos[index]
                        
                        let usd = crypto.priceUSDAsDouble * ownCrypto.amount
                        let btc = crypto.priceBTCAsDouble * ownCrypto.amount
                        
                        // Update the Portfolio Amount
                        if amount != nil {
                            amount?.add(usd: usd, btc: btc)
                        } else {
                            amount = PortfolioAmount(usd: usd, btc: btc)
                        }
                        
                        // Update the Coin
                        ownCrypto.dollarValue = usd
                        if let store = self?.store {
                            self?.update(ownCrypto, in: store)
                        }

                    }

                }
                
                return amount
        }
        
        // Migration Process
        let standardStore = Defaults.shared
        let oldList = self.getAll(store: standardStore)
        
        oldList.forEach { crypto in
            
            self.add(crypto)
            
            self.remove(crypto, from: standardStore)
            
        }
        
        self.updatePortfolio()
        
        // Simuator
        if Environment.isSimulator {
            self.removeAll(from: store)
        }
        
    }
    
    func updatePortfolio() {
        self.updatedPortfolio.onNext(self.getAll(store: store))
    }
    
    func getAll() -> [OwningCryptoCurrency] {
        return self.getAll(store: self.store)
    }
    
    private func getAll(store: Defaults) -> [OwningCryptoCurrency] {
        
        var portfolio = [OwningCryptoCurrency]()
        
        let list = self.getList(from: store)
        
        for ident in list {
            
            if let crypto = store.get(for: Key<OwningCryptoCurrency>(ident)) {
                portfolio.append(crypto)
            }
            
        }
        
        return portfolio
        
    }
    
    func add(_ currency: OwningCryptoCurrency) {
        self.add(currency, to: self.store)
    }
    
    private func add(_ currency: OwningCryptoCurrency, to store: Defaults) {

        // Add to List
        self.addToList(currency, in: store)
        
        // Add to the Store
        store.set(currency, for: Key<OwningCryptoCurrency>(currency.ident))
        
        // Update Portfolio
        self.updatePortfolio()
        
    }
    
    func update(_ currency: OwningCryptoCurrency, in store: Defaults) {
        
        // Add to the Store
        store.set(currency, for: Key<OwningCryptoCurrency>(currency.ident))
        
        // Update Portfolio
        self.updatePortfolio()
        
    }
    
    func remove(_ currency: OwningCryptoCurrency) {
        self.remove(currency, from: self.store)
    }
    
    private func remove(_ currency: OwningCryptoCurrency, from store: Defaults) {
        
        // Remove from Store
        store.clear(Key<OwningCryptoCurrency>(currency.ident))
        
        // Remove from list
        self.removeFromList(currency, of: store)
        
        // Update Portfolio
        self.updatePortfolio()
        
    }
    
    func removeAll(from store: Defaults) {
        
        let all = self.getAll(store: store)
        
        all.forEach { self.remove($0, from: store) }
        
    }
    
    private func getList(from store: Defaults) -> [String] {
        let key = Key<[String]>(self.listKey)
        return store.get(for: key) ?? []
    }
    
    private func setlist(list: [String], in store: Defaults) {
        let key = Key<[String]>(self.listKey)
        store.set(list, for: key)
    }
    
    private func addToList(_ currency: OwningCryptoCurrency, in store: Defaults) {
        
        var list = self.getList(from: store)
        
        list.append(currency.ident)
        
        self.setlist(list: list, in: store)
    }
    
    private func removeFromList(_ currency: OwningCryptoCurrency, of store: Defaults) {
        
        var list = self.getList(from: store)
        
        if let index = list.index(of: currency.ident) {
            list.remove(at: index)
        }
        
        self.setlist(list: list, in: store)
        
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
