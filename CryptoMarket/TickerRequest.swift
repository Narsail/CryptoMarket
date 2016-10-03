//
//  ExerciseTypeRequests.swift
//  EMNetwork
//
//  Created by David Moeller on 06/09/2016.
//
//

import Foundation

class TickerRequest: BackendAPIRequestProtocol {
	
	var endpoint: String {
		return "/public?command=returnTicker"
	}
	
	var method: NetworkService.Method {
		return .GET
	}
	
	var parameters: [String: Any]? {
		return nil
	}
	
	var headers: [String: String]? {
		return self.defaultJSONHeaders()
	}
	
}
