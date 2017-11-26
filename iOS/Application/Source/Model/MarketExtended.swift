//
//  MarketExtended.swift
//  CryptoMarket
//
//  Created by David Moeller on 26.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation

class MarketExtended: Codable {
    
    // Base
    
    let ident: String
    let name: String
    let percentChange24h: String
    let priceBTC: String
    let priceUSD: String
    let marketCapUSD: String
    
    // Extended
    
    let symbol: String // i.e. BTC
    let rank: String
    let volume24hUSD: String
    let availableSupply: String
    let totalSupply: String
    let maxSupply: String?
    let percentChange1h: String
    let percentChange7d: String
    
    var percentChange24hAmount: Double? {
        return Double(self.percentChange24h)
    }
    var percentChange1hAmount: Double? {
        return Double(self.percentChange1h)
    }
    var percentChange7dAmount: Double? {
        return Double(self.percentChange7d)
    }
    var formattedMarketCap: String {
        
        let suffix = " USD"
        
        guard let cap = Double(self.marketCapUSD) else { return marketCapUSD + " USD" }
        
        var formattedCap = marketCapUSD
        
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
        case percentChange24h = "percent_change_24h"
        case priceBTC = "price_btc"
        case priceUSD = "price_usd"
        case marketCapUSD = "market_cap_usd"
        case symbol
        case rank
        case volume24hUSD = "24h_volume_usd"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case percentChange1h = "percent_change_1h"
        case percentChange7d = "percent_change_7d"
    }
    
}
