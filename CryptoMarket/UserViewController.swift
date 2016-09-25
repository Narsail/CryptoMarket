//
//  UserViewController.swift
//  CryptoMarket
//
//  Created by David Moeller on 23/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit
import Stevia

class UserNavigationController: UINavigationController {
	
	init(tabBarItem: UITabBarItem) {
		super.init(nibName: nil, bundle: nil)
		self.tabBarItem = tabBarItem
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

class UserViewController: SubRootViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "User"
		
		self.view.backgroundColor = UIColor.white
		
		let label = UILabel()
		label.text = "User Test"
		label.sizeToFit()
		
		self.view.sv([label])
		self.view.layout(
			label.centerVertically().centerHorizontally()
		)
	}
}
