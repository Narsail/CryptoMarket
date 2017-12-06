//
//  Market.swift
//  CryptoMarket
//
//  Created by David Moeller on 25.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit

class Cryptocurrency: Codable {
    
    let ident: String
    let name: String
    let symbol: String
    let percentChange24h: String?
    let priceBTC: String?
    let priceUSD: String?
    let marketCapUSD: String?
    
    var percentChange24hAmount: Double? {
        if let change = percentChange24h {
            return Double(change)
        }
        return nil
    }
    var priceUSDAsDouble: Double {
        return Double(priceUSD ?? "") ?? 0
    }
    var priceBTCAsDouble: Double {
        return Double(priceBTC ?? "") ?? 0
    }
    
    var formattedMarketCap: String {
        
        let suffix = " USD"
        
        guard let capAsString = self.marketCapUSD else { return "Unknown" }
        guard let cap = Double(capAsString) else { return capAsString + " USD" }
        
        var formattedCap = capAsString
        
        switch cap {
        case let cap where cap >= 1000000000000:
            formattedCap = String(format: "%.2f", cap/1000000000000) + "trillion"
        case let cap where cap >= 1000000000:
            formattedCap = String(format: "%.2f", cap/1000000000) + "bn"
        case let cap where cap >= 1000000:
            formattedCap = String(format: "%.2f", cap/1000000) + "m"
        case let cap where cap >= 1000:
            formattedCap = String(format: "%.2f", cap/1000) + "k"
        default:
            break
        }
        
        return formattedCap + suffix

    }
    
    enum CodingKeys: String, CodingKey {
        case ident = "id"
        case name
        case symbol
        case percentChange24h = "percent_change_24h"
        case priceBTC = "price_btc"
        case priceUSD = "price_usd"
        case marketCapUSD = "market_cap_usd"
    }
    
}

extension Cryptocurrency: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return ident as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? Cryptocurrency {
            return self.ident == object.ident
        }
        return false
    }
    
}
