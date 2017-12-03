//
//  MainTabBarCoordinator.swift
//  CryptoMarket
//
//  Created by David Moeller on 28.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class MainTabBarCoordinator: BaseCoordinator<Void> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        
        let tabBarController = UITabBarController()
        
        let firstTab = UINavigationController()
        let firstTabItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "list"), tag: 0)
        firstTabItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        firstTab.tabBarItem = firstTabItem
        
        let secondTab = UINavigationController()
        let secondTabItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "coin"), tag: 1)
        secondTabItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        secondTab.tabBarItem = secondTabItem
        
        tabBarController.viewControllers = [firstTab, secondTab]
        
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.layer.borderWidth = 0
        tabBarController.tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBarController.tabBar.clipsToBounds = true
        
        self.rootViewController.present(tabBarController, animated: true, completion: nil)
        
        // Coordinators
        self.coordinate(to: MarketListCoordinator(rootViewController: firstTab)).subscribe().disposed(by: disposeBag)
        self.coordinate(to: PortfolioCoordinator(rootViewController: secondTab)).subscribe().disposed(by: disposeBag)
        
        return .never()
    }
    
}
