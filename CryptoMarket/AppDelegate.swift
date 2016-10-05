//
//  AppDelegate.swift
//  CryptoMarket
//
//  Created by David Moeller on 19/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit
import Chameleon

var projectColors: ProjectColor = ProjectColor(mainColor: UIColor.flatWhite(), mainColorDark: UIColor.flatWhiteColorDark())

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var rootRouter: RatesRouter?
	
	var launchedShortcutItem: UIApplicationShortcutItem?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// Store shortcut Item
		if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
			
			launchedShortcutItem = shortcutItem
			
		}
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		let initialiViewController = UINavigationController()
		
		rootRouter = RatesRouter(root: initialiViewController)
		
		self.window?.rootViewController = initialiViewController
		self.window?.makeKeyAndVisible()
		
		rootRouter?.start()
		
		return true
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		
		guard let shortcut = launchedShortcutItem else { return }
		
		let _ = handleShortCutItem(shortcutItem: shortcut)
		
		launchedShortcutItem = nil
	}
	
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		let handledShortCutItem = handleShortCutItem(shortcutItem: shortcutItem)
		
		completionHandler(handledShortCutItem)
	}

	func presentAlertView(alertType: AlertType) {
		
		var title: String!
		var message: String!
		
		switch alertType {
		case .slowInternet:
			title = "Slow/Unstable Internet Connection."
			message = "Your Internet Connection is slow and/or unstable and therefore the shown data might be not up to date."
		case .noInternet:
			title = "No Internet Connection."
			message = "Please check your Internet Connection."
		}
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
		rootRouter?.viewController?.present(alert, animated: true, completion: nil)
	}


}

extension AppDelegate {
	
	func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
		var handled = false
		
		// Verify that the provided `shortcutItem`'s `type` is one handled by the application.
		
		guard let type = ShortCutType(rawValue: shortcutItem.type) else { return false }
		
		switch type {
		case .firstFavourite:
			handled = self.rootRouter?.handleShortCut(favouriteNumber: 0) ?? false
		case .secondFavourite:
			handled = self.rootRouter?.handleShortCut(favouriteNumber: 1) ?? false
		case .thirdFavourite:
			handled = self.rootRouter?.handleShortCut(favouriteNumber: 2) ?? false
		}
		
		return handled
	}
}

enum AlertType {
	case slowInternet
	case noInternet
}



