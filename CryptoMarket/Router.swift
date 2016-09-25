//
//  Router.swift
//  CryptoMarket
//
//  Created by David Moeller on 23/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import UIKit

protocol Routing: class {
	associatedtype RootViewController: UIViewController
	associatedtype ViewController: UIViewController
	var root: RootViewController { get }
	var viewController: ViewController? { get set }
	func createViewController() -> ViewController
	func configure(_ viewController: ViewController)
	func show(_ viewController: ViewController)
	func dismiss()
}
extension Routing {
	func start() {
		let vc = createViewController()
		viewController = vc
		configure(vc)
		show(vc)
	}
	func stop() {
		dismiss()
		viewController = nil
	}
}

extension Routing {
	func configure(_ viewController: ViewController) {
	}
	func show(_ viewController: ViewController) {
		root.present(viewController, animated: true , completion: nil)
	}
	func dismiss() {
		root.dismiss(animated: true, completion: nil)
	}
}

protocol NavigationRouting: Routing {
	typealias RootViewController = UINavigationController
}
extension NavigationRouting {
	func show(_ viewController: Self.ViewController) {
		root.pushViewController(viewController, animated: true)
	}
	func dismiss() {
		root.dismiss(animated: true, completion: nil)
	}
}

protocol TabbarRouting: Routing {
	typealias RootViewController = UITabBarController
}

