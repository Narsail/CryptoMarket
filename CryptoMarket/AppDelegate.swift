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

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		let initialiViewController = UINavigationController()
		
		rootRouter = RatesRouter(root: initialiViewController)
		
		self.window?.rootViewController = initialiViewController
		self.window?.makeKeyAndVisible()
		
		rootRouter?.start()
		
		return true
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

enum AlertType {
	case slowInternet
	case noInternet
}

