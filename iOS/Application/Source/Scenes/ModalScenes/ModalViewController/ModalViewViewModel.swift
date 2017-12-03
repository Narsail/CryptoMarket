//
//  ModalViewViewModel.swift
//  Evomo
//
//  Created by David Moeller on 08.11.17.
//  Copyright © 2017 Evomo. All rights reserved.
//

import Foundation
import RxSwift

class ModalViewViewModel {
    
    // Inputs
    
    let cancel: AnyObserver<Void>
    
    // Outputs
    
    var dismiss: Observable<Void> = Observable.empty()
    
    init() {
        
        // Connect Input
        let cancelSubject = PublishSubject<Void>()
        cancel = cancelSubject.asObserver()
        
        // to Output
        dismiss = cancelSubject
        
    }
    
}
