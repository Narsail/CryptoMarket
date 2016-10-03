//
//  RatesRouter.swift
//  CryptoMarket
//
//  Created by David Moeller on 29/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import BrightFutures


class SettingsRouter: SubRootRouter {
	
	override init(root: UINavigationController) {
		
		super.init(root: root)

	}
	
	override func createViewController() -> SubRootViewController {
		return SettingsViewController()
	}
	
}
