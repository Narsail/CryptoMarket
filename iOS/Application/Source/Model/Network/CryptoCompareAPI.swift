//
//  CryptoCompareAPI.swift
//  CryptoMarket
//
//  Created by David Moeller on 13.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import Siesta
import RxSwift

class CryptoCompareAPI {
    
    // Shared Instance
    static let shared = CryptoCompareAPI()
    
    private let service = Service(baseURL: "https://min-api.cryptocompare.com/data")
    
    private let disposeBag = DisposeBag()
    
    fileprivate init() {
        
        #if DEBUG
            LogCategory.enabled = LogCategory.common
        #endif
        
        // –––––– Global configuration ––––––
        let jsonDecoder = JSONDecoder()
        
        service.configure("/histoday") {
            $0.pipeline.removeAllTransformers()
        }
        service.configureTransformer("/histoday") {
            try jsonDecoder.decode(HistoDayResponse.self, from: $0.content)
        }
        
    }
    
    func historicalData(fromSymbol: String, toSymbol: String, exchange: String) -> Resource {
        return service.resource("/histoday")
            .withParam("fsym", fromSymbol)
            .withParam("tsym", toSymbol)
            .withParam("e", exchange)
            .withParam("limit", "180")
    }
}

struct HistoDayResponse: Codable {
    
    let response: String
    let type: Int
    let aggregated: Bool
    let firstValueInArray: Bool
    let timeTo: Int
    let timeFrom: Int
    
    let data: [HistoDayData]
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case type = "Type"
        case aggregated = "Aggregated"
        case firstValueInArray = "FirstValueInArray"
        case timeTo = "TimeTo"
        case timeFrom = "TimeFrom"
        case data = "Data"
    }
    
}

struct HistoDayData: Codable {
    
    let time: Int
    let close: Double
    
}
