//
//  MarketDetailCoordinator.swift
//  CryptoMarket
//
//  Created by David Moeller on 26.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import RxSwift

class MarketDetailCoordinator: BaseCoordinator<Void> {
    
    private let rootViewController: UIViewController
    private let marketIdent: String
    private let marketName: String
    
    init(rootViewController: UIViewController, marketIdent: String, marketName: String) {
        self.rootViewController = rootViewController
        self.marketIdent = marketIdent
        self.marketName = marketName
    }
    
    override func start() -> Observable<Void> {
        
        let viewModel = MarketDetailViewModel(marketID: marketIdent, name: marketName)
        let viewController = MarketDetailViewController(viewModel: viewModel)
        
        if let navigationController = rootViewController as? UINavigationController {
            // viewController.isEmbeddedInNavigationViewController = true
            navigationController.pushViewController(viewController, animated: true)
        } else {
            self.rootViewController.present(viewController, animated: true, completion: nil)
        }
        
        return viewModel.isDismissing.do(onNext: { viewController.dismiss(animated: true, completion: nil) })
        
    }
    
}
