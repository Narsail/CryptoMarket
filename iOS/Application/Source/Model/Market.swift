//
//  Market.swift
//  CryptoMarket
//
//  Created by David Moeller on 25.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit

class Market: Codable {
    
    let ident: String
    let name: String
    let percentChange24h: String
    let priceBTC: String
    let priceUSD: String
    
    var percentChange24hAmount: Double? {
        return Double(self.percentChange24h)
    }
    
    enum CodingKeys: String, CodingKey {
        case ident = "id"
        case name
        case percentChange24h = "percent_change_24h"
        case priceBTC = "price_btc"
        case priceUSD = "price_usd"
    }
    
}

extension Market: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return ident as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? Market {
            return self.ident == object.ident
        }
        return false
    }
    
}
