//
//  RootCoordinator.swift
//  CryptoMarket
//
//  Created by David Moeller on 23/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import UIKit

class RootRouter: NSObject, TabbarRouting {
	let root: UITabBarController
	var viewController: UINavigationController?
	
	var subRouters = [UINavigationController: SubRootRouter]()
	
	init(root: UITabBarController) {
		self.root = root
		super.init()
		configure(withRootController: self.root)
	}
	
	func createViewController() -> UINavigationController {
		
		if let vc = root.selectedViewController as? UINavigationController {
			return vc
		}
		return RatesNavigationController(tabBarItem: UITabBarItem(title: "Rates", image: UIImage(named: "Rates"), tag: 0))
	}
	
	func configure(_ viewController: UINavigationController) {
		return
	}
	
	func configure(withRootController rootController: UITabBarController) {
		
		let ratesNavigationController = RatesNavigationController(tabBarItem: UITabBarItem(title: "Rates", image: UIImage(named: "Rates"), tag: 0))
		let userNavigationController = SettingsNavigationController(tabBarItem: UITabBarItem(title: "Settings", image: UIImage(named: "Settings"), tag: 1))
		
		// Add ViewController
		
		rootController.setViewControllers([ratesNavigationController, userNavigationController], animated: true)
		
		rootController.delegate = self
	}
	
	func start() {

		let vc = createViewController()
		viewController = vc
		
		handleNavigationController(withNavigationController: vc)

	}
	
	func handleNavigationController(withNavigationController navigationController: UINavigationController) {
		
		if !subRouters.keys.contains(navigationController) {
			if navigationController is RatesNavigationController {
				let subRouter = RatesRouter(root: navigationController)
				subRouter.start()
				subRouters[navigationController] = subRouter
			} else if navigationController is SettingsNavigationController {
				let subRouter = SettingsRouter(root: navigationController)
				subRouter.start()
				subRouters[navigationController] = subRouter
			}
		}
		
	}
	
}

extension RootRouter: UITabBarControllerDelegate {
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		
		handleNavigationController(withNavigationController: viewController as! UINavigationController)
		
	}
	
}

class SubRootRouter: NSObject, NavigationRouting {
	
	let root: UINavigationController
	var viewController: SubRootViewController?
	
	init(root: UINavigationController) {
		self.root = root
	}
	
	func createViewController() -> SubRootViewController {
		fatalError("Not implemented")
	}
	
	func configure(_ viewController: SubRootViewController) {
		return
	}
	
}
