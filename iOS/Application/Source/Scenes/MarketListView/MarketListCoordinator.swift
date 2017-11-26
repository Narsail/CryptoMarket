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
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.shadowImage = UIImage()
        
        self.rootViewController.present(navigationController, animated: true, completion: nil)
        
        viewModel.selectedMarket.flatMap({ (ident, name) in
            self.coordinate(to:
                MarketDetailCoordinator(rootViewController: navigationController, marketIdent: ident, marketName: name)
            )
        }).subscribe().disposed(by: self.disposeBag)
        
        return Observable.never()
        
    }
    
}
