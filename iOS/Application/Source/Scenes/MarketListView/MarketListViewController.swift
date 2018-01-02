//
//  AppointmentListViewController.swift
//  SmartNetworkung
//
//  Created by David Moeller on 13.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import IGListKit
import Stevia
import Crashlytics
import RxCocoa
import SwiftDate
import CollectionKit

class MarketListViewController: RxSwiftViewController {

    let viewModel: MarketListViewModel
    
    let collectionView: CollectionView = {
        
        let view = CollectionView()
        
        return view
    }()
    
//    let collectionView: UICollectionView = {
//
//        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
//
//        let topInset: CGFloat = 15
//        let bottomInset: CGFloat = 0
//
//        view.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
//        view.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
//        view.alwaysBounceVertical = true
//
//        view.backgroundColor = .clear
//
//        return view
//    }()
    
    func prepareRefreshControl() -> UIRefreshControl {
        let control = UIRefreshControl()
        
        control.attributedTitle = NSAttributedString(string: Strings.RefreshControl.title)
        
        if Environment.isIOS11 {
            control.tintColor = .white
        } else {
            control.tintColor = .gray
        }
        
        control.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        return control
    }
    
    init(viewModel: MarketListViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        /* Non self Initialization */
        
        // Sort Icon
        let sortItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "sort"), style: UIBarButtonItemStyle.plain, target: nil, action: nil
        )
        sortItem.tintColor = Color.navigationBarItems.asUIColor
        
        self.navigationItem.leftBarButtonItem = sortItem
        
        sortItem.rx.tap
            .map { _ in
                try !self.viewModel.showSort.value()
            }
            .do(onNext: { show in
                if show && !Environment.isDebug {
                    Answers.logCustomEvent(withName: "Show Sort Options", customAttributes: nil)
                }
            }).bind(to: self.viewModel.showSort).disposed(by: disposeBag)
        
        self.viewModel.showSort.subscribe(onNext: { show in
//            if show && self.collectionView.numberOfSections > 0 {
//                self.collectionView.scrollToItem(
//                    at: IndexPath(item: 0, section: 1), at: .centeredVertically, animated: true
//                )
//            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        // Background
        self.view.backgroundColor = Color.backgroundColor.asUIColor
        
        // Navbar Settings
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        
        if Environment.isIOS11 {
            
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.autocorrectionType = .yes
            searchController.searchBar.barTintColor = Color.navigationBarItems.asUIColor
            searchController.searchBar.tintColor = Color.navigationBarItems.asUIColor
            searchController.dimsBackgroundDuringPresentation = false
            
            searchController.searchBar.rx.text.orEmpty.bind(to: self.viewModel.filter).disposed(by: disposeBag)
            searchController.rx.didDismiss.map { return "" }.bind(to: self.viewModel.filter).disposed(by: disposeBag)
            
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationItem.largeTitleDisplayMode = .always
                self.navigationItem.title = Strings.NavigationBarItems.cryptocurrencies
                self.navigationItem.searchController = searchController
                self.navigationItem.hidesSearchBarWhenScrolling = false
            }
            
        }
        
        self.view.sv(
            self.collectionView
        )
        
        setupLayout()
        setupCollectionView()
        
        hideKeyboardWhenTappedAround()
        
        self.viewModel.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !Environment.isDebug {
            Answers.logCustomEvent(withName: "Show Market List View",
                                   customAttributes: ["Uses Portfolio": !Portfolio.shared.getAll().isEmpty])
        }
    }
    
    func setupLayout() {
        
        self.view.layout(
            |-self.collectionView-|
        )
        
        self.collectionView.Top == topLayoutGuide.Bottom
        self.collectionView.Bottom == bottomLayoutGuide.Top
    }
    
    @objc func refresh() {
        self.viewModel.reloadData()
        if !Environment.isDebug {
            Answers.logCustomEvent(withName: "Reloaded Coins.", customAttributes: nil)
        }
    }
    
//    var adapter: RxListAdapter? {
//        didSet {
//
//            guard let adapter = self.adapter else { return }
//
//            adapter.collectionView = collectionView
//            adapter.dataSource = viewModel
//
//
//            self.viewModel.filtern.observeOn(MainScheduler.instance).subscribe(onNext: { _ in
//                adapter.performUpdates(animated: true, completion: nil)
//            }).disposed(by: adapter.disposeBag)
//        }
//    }
    
    func setupCollectionView() {
        
        collectionView.refreshControl = prepareRefreshControl()
        
        // Test Setup
        collectionView.provider = self.viewModel.providerComposer
        
        // Define end of refreshing
        self.viewModel.contentUpdated.observeOn(MainScheduler.instance).subscribe(onNext: { _ in
            self.collectionView.refreshControl?.endRefreshing()
            if let lastUpdate = CoinMarketCapAPI.shared.lastUpdate {
                self.collectionView.refreshControl?.attributedTitle = NSAttributedString(
                    string: Strings.RefreshControl.lastUpdate +
                        lastUpdate.string(dateStyle: .none, timeStyle: DateFormatter.Style.medium, in: nil)
                )
            }
        }).disposed(by: self.disposeBag)

//        adapter = RxListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
        
    }
    
}
