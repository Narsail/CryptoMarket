//
//  Global.swift
//  CryptoMarket
//
//  Created by David Moeller on 27.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit

class Global: Codable {
    
    let totalMarketCapUSD: Double
    let totalVolume24h: Double
    let bitcoinPercentageOfMarketCap: Double

    var formattedMarketCap: String {
        
        let suffix = " USD"
        
        let formattedCap = formatted(totalMarketCapUSD)
        
        return formattedCap + suffix
        
    }
    
    var formattedVolume: String {
        
        let suffix = " USD"
        
        let formattedCap = formatted(totalVolume24h)
        
        return formattedCap + suffix
        
    }
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCapUSD = "total_market_cap_usd"
        case totalVolume24h = "total_24h_volume_usd"
        case bitcoinPercentageOfMarketCap = "bitcoin_percentage_of_market_cap"
    }
    
}

extension Global: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return "\(totalMarketCapUSD)" as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? Global {
            return (self.totalMarketCapUSD, self.totalVolume24h, self.bitcoinPercentageOfMarketCap) ==
                (object.totalMarketCapUSD, object.totalVolume24h, object.bitcoinPercentageOfMarketCap)
        }
        return false
    }
    
}

func formatted(_ number: Double) -> String {
    
    var formatted = "\(number)"
    
    switch number {
    case let number where number >= 1000000000000:
        formatted = String(format: "%.2f", number/1000000000000) + "trillion"
    case let number where number >= 1000000000:
        formatted = String(format: "%.2f", number/1000000000) + "bn"
    case let number where number >= 1000000:
        formatted = String(format: "%.2f", number/1000000) + "m"
    case let number where number >= 1000:
        formatted = String(format: "%.2f", number/1000) + "k"
    default:
        break
    }
    return formatted
}
