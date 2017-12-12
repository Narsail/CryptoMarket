//
//  OwningCryptoCurrency.swift
//  CryptoMarket
//
//  Created by David Moeller on 28.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit

class OwningCryptoCurrency: Codable {
    
    let ident: String
    let symbol: String
    let amount: Double
    
    // USD Value
    var dollarValue: Double?
    
    init(symbol: String, amount: Double, ident: String = UUID().uuidString) {
        self.symbol = symbol
        self.amount = amount
        self.ident = ident
    }
    
}

extension OwningCryptoCurrency: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return ident as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? OwningCryptoCurrency {
            return self.ident == object.ident
        }
        return false
    }
    
}
