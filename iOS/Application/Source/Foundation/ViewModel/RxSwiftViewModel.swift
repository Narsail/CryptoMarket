//
//  RxSwiftViewModel.swift
//  CryptoMarket
//
//  Created by David Moeller on 26.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import RxSwift

class RxSwiftViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    // MARK: - Inputs
    
    let dismiss: AnyObserver<Void>
    
    // MARK: - Outputs
    
    let isDismissing: Observable<Void>
    
    override init() {
        
        let dismissSubject = PublishSubject<Void>()
        dismiss = dismissSubject.asObserver()
        
        isDismissing = dismissSubject
        
        super.init()
        
    }
    
}
