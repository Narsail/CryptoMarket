//
//  ModelPresentedViewController.swift
//  CryptoMarket
//
//  Created by David Moeller on 02.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import UIKit
import RxSwift

class ModalPresentedViewController<ModalResult>: UIViewController, ModalDisplayable {
    
    let dismiss = PublishSubject<ModalResult>()
    
    var modalTitle: String {
        return "Modal Displayable"
    }
    
}
