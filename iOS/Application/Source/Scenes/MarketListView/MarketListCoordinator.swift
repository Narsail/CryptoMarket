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
        
        var navigationViewController = UINavigationController(rootViewController: viewController)
        
        if let navigationController = self.rootViewController as? UINavigationController {
            navigationViewController = navigationController
        }
        
        navigationViewController.navigationBar.barTintColor = .white
        navigationViewController.navigationBar.isTranslucent = true
        navigationViewController.navigationBar.shadowImage = UIImage()
        
        if self.rootViewController is UINavigationController {
            navigationViewController.viewControllers = [viewController]
        } else {
            self.rootViewController.present(viewController, animated: true, completion: nil)
        }
        
        viewController.viewModel.selectedMarket.flatMap({ (ident, name) in
            self.coordinate(to:
                MarketDetailCoordinator(rootViewController: navigationViewController,
                                        marketIdent: ident, marketName: name)
            )
        }).subscribe().disposed(by: self.disposeBag)
        
        return Observable.never()
        
    }
    
}
