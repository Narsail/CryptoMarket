//
//  ViewController.swift
//  CryptoMarket
//
//  Created by David Moeller on 19/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit
import Stevia
import HidingNavigationBar

class RatesNavigationController: UINavigationController {
	
	init(tabBarItem: UITabBarItem) {
		super.init(nibName: nil, bundle: nil)
		self.tabBarItem = tabBarItem
		self.navigationController?.hidesNavigationBarHairline = true
		// self.navigationBar.backgroundColor = projectColors.navigationBarColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

class RatesViewController: SubRootViewController {
	
	let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = projectColors.mainColor
		tableView.estimatedRowHeight = 100
		tableView.register(TickerTableViewCell.self, forCellReuseIdentifier: "tickerCell")
		tableView.separatorStyle = .none
		return tableView
	}()
	
	var hidingBarManager: HidingNavigationBarManager?
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		// Configure Views
		configureUserInterface()
		
		// Load TableView Content
		self.tableView.reloadData()
		
	}
	
	func configureUserInterface() {
		
		// Set Titles
		
		self.title = "CryptoMarket"
		
		// Set Constraints
		
		view.sv(tableView)
		view.layout(
			0,
			|tableView|,
			0
		)
		
		// Set Hiding Bar Manager
		hidingBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
		hidingBarManager?.expansionResistance = 150
		// hidingBarManager?.refreshControl = refreshControl
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		hidingBarManager?.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		hidingBarManager?.viewWillDisappear(animated)
	}
	
}

