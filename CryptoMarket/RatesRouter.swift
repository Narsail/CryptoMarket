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


class RatesRouter: SubRootRouter {
	
	var notificationToken: NotificationToken? = nil
	var tickerData: Results<Ticker>
	
	var marketDetailData: RatesDetailRouter?
	
	var timer: Timer?
	
	override init(root: UINavigationController) {
		
		self.tickerData = Store.realm.objects(Ticker.self).sorted(byProperty: "sortingLabel")
		super.init(root: root)
		
		notificationToken = tickerData.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
			
			guard let viewController = self?.viewController as? RatesViewController, let isEmpty = self?.tickerData.isEmpty else { return }
			
			let tableView = viewController.tableView
			
			viewController.showNoContentLabel(show: isEmpty)
			
			switch changes {
			case .initial:
				// Results are now populated and can be accessed without blocking the UI
				tableView.reloadData()
				break
			case .update(_, let deletions, let insertions, let modifications):
				// Query results have changed, so apply them to the UITableView
				tableView.beginUpdates()
				tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
				tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
				tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .none)
				tableView.endUpdates()
				break
			case .error(let error):
				// An error occurred while opening the Realm file on the background worker thread
				fatalError("\(error)")
				break
			}
			
		}
		
		// Set Fetch Timer
		self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
			// Fetch Data
			self.fetchTickers()
		})
		self.timer?.fire()
	}
	
	override func configure(_ viewController: SubRootViewController) {
		
		if let viewController = viewController as? RatesViewController {
			// Configure Table View
			viewController.tableView.delegate = self
			viewController.tableView.dataSource = self
		}

	}
	
	override func createViewController() -> SubRootViewController {
		return RatesViewController()
	}
	
	func stop() {
		self.timer?.invalidate()
		dismiss()
		viewController = nil
	}
	
}

extension RatesRouter {
	
	// MARK: - Fetching
	
	func fetchTickers() {
		
		PoloniexAPI.shared.fetchTickers().map(ImmediateExecutionContext) { list in
			Store.save(withTickers: list)
			}.onFailure { error in
				NSLog("Error occurred: \(error)")
		}
		
	}
	
}

extension RatesRouter: UITableViewDelegate, UITableViewDataSource {
	
	// MARK: - Delegate/Datasource - TableView
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return tickerData.count
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "tickerCell", for: indexPath) as! TickerTableViewCell
		
		let ticker = tickerData[indexPath.row]
		
		cell.initialize(withTicker: ticker)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let ticker = tickerData[indexPath.row]
		marketDetailData = RatesDetailRouter(root: self.root, ticker: ticker)
		marketDetailData?.start()
		
	}
	
}
