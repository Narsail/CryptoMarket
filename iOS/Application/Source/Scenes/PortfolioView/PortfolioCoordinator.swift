//
//  PortfolioCoordinator.swift
//  CryptoMarket
//
//  Created by David Moeller on 29.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PortfolioCoordinator: BaseCoordinator<Void> {
    
    private let rootViewController: UIViewController
    private let modalTransitionDelegate = ModalTransitionDelegate(type: .regular)
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        
        let viewModel = PortfolioViewModel()
        let viewController = PortfolioViewController(viewModel: viewModel)
        
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
        
        viewModel.addPortfolioItem.flatMap {
            self.coordinate(to: ModalViewCoordinator(
                rootViewController: viewController,
                modelPresentableViewController: AddPortfolioItemViewController()
            ))
        }.do(onNext: { result in
            
            switch result {
            case .dismissedWithoutResult:
                break
            case .dismissedWithResult(result: let crypto):
                viewModel.addToPortfolio(crypto: crypto)
            }
                
        }).subscribe().disposed(by: disposeBag)
        
        return Observable.never()
        
    }
    
}
