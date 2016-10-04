//
//  ViewController.swift
//  CryptoMarket
//
//  Created by David Moeller on 19/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit
import Stevia

class RatesNavigationController: UINavigationController {
	
	init(tabBarItem: UITabBarItem) {
		super.init(nibName: nil, bundle: nil)
		self.tabBarItem = tabBarItem
		self.navigationController?.hidesNavigationBarHairline = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

class RatesViewController: SubRootViewController {
	
	let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = projectColors.mainComplementColor
		tableView.estimatedRowHeight = 100
		tableView.register(TickerTableViewCell.self, forCellReuseIdentifier: "tickerCell")
		tableView.separatorStyle = .none
		return tableView
	}()
	let noContentLabel: UILabel = {
		let label = UILabel()
		label.text = "No Content available."
		label.isHidden = true
		return label
	}()
	let noContentLabelExtension: UILabel = {
		let label = UILabel()
		label.text = "(Please check your Internet Connection)"
		label.isHidden = true
		return label
	}()
	
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
		
		view.sv(tableView, noContentLabel, noContentLabelExtension)
		view.layout(
			0,
			|tableView|,
			0
		)
		view.layout(
			noContentLabel.centerVertically().centerHorizontally(),
			noContentLabelExtension.centerHorizontally()
		)
		
	}
	
	func showNoContentLabel(show: Bool) {
		noContentLabel.isHidden = !show
		noContentLabelExtension.isHidden = !show
	}
	
}

