//
//  AppointmentListCoordinator.swift
//  SmartNetworkung
//
//  Created by David Moeller on 13.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MarketListCoordinator: BaseCoordinator<Void> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        
        let viewModel = MarketListViewModel()
        let viewController = MarketListViewController(viewModel: viewModel)
        
        self.rootViewController.present(viewController, animated: true, completion: nil)
        
        return Observable.never()
        
    }
    
}
