//
//  CoinMarketCapAPI.swift
//  CryptoMarket
//
//  Created by David Moeller on 25.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import Siesta

class CoinMarketCapAPI {
    
    private let service = Service(baseURL: "https://api.coinmarketcap.com/v1")
    
    fileprivate init() {
        #if DEBUG
            // Bare-bones logging of which network calls Siesta makes:
            //LogCategory.enabled = [.network]
            
            // For more info about how Siesta decides whether to make a network call,
            // and which state updates it broadcasts to the app:
            //LogCategory.enabled = LogCategory.common
            
            // For the gory details of what Siesta’s up to:
            //LogCategory.enabled = LogCategory.all
            
            // To dump all requests and responses:
            // (Warning: may cause Xcode console overheating)
            LogCategory.enabled = LogCategory.detailed
        #endif
        
        // –––––– Global configuration ––––––
        let jsonDecoder = JSONDecoder()
        
        // –––––– Resource-specific configuration ––––––
        service.configure("/ticker") {
            $0.pipeline.removeAllTransformers()
        }
        service.configureTransformer("/ticker") {
            try jsonDecoder.decode([Market].self, from: $0.content)
        }
        service.configure("/ticker/*") {
            $0.pipeline.removeAllTransformers()
        }
        service.configureTransformer("/ticker/*") {
            try jsonDecoder.decode([MarketExtended].self, from: $0.content)
        }
        service.configure("/global") {
            $0.pipeline.removeAllTransformers()
        }
        service.configureTransformer("/global") {
            try jsonDecoder.decode(Global.self, from: $0.content)
        }
    }
    
    static let shared = CoinMarketCapAPI()
    
    var global: Resource {
        return service
            .resource("/global")
    }
    var markets: Resource {
        return service
            .resource("/ticker").withParam("limit", "0")
    }
    func market(_ ident: String) -> Resource {
        return self.markets.child(ident)
    }
    
}