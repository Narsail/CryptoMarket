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

class MarketListViewController: RxSwiftViewController {

    let viewModel: MarketListViewModel
    
    let collectionView: UICollectionView = {
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        let topInset: CGFloat = 0
        let bottomInset: CGFloat = 15
        
        view.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        view.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        view.alwaysBounceVertical = true
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    func prepareRefreshControl() -> UIRefreshControl {
        let control = UIRefreshControl()
        
        control.attributedTitle = NSAttributedString(string: Strings.RefreshControl.title)
        control.tintColor = .gray
        control.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        return control
    }
    
    init(viewModel: MarketListViewModel) {
        
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        /* Non self Initialization */
        self.viewModel.displayDelegate = self
        
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
            if show && self.collectionView.numberOfSections > 1 {
                self.collectionView.scrollToItem(
                    at: IndexPath(item: 0, section: 1), at: .centeredVertically, animated: true
                )
            }
        }).disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        // Background
        self.view.backgroundColor = Color.backgroundColor.asUIColor
        self.navigationController?.view.backgroundColor = Color.backgroundColor.asUIColor
        
        // Navbar Settings
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.autocorrectionType = .yes
        searchController.searchBar.barTintColor = Color.navigationBarItems.asUIColor
        searchController.searchBar.tintColor = Color.navigationBarItems.asUIColor
        searchController.searchBar.backgroundColor = Color.backgroundColor.asUIColor
    
        searchController.view.backgroundColor = UIColor.clear
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.rx.text.orEmpty.bind(to: self.viewModel.filter).disposed(by: disposeBag)
        searchController.rx.didDismiss.map { return "" }.bind(to: self.viewModel.filter).disposed(by: disposeBag)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = Strings.NavigationBarItems.cryptocurrencies
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
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
        
        self.view.sv(
            self.collectionView
        )
        
        self.view.layout(
            0,
            |-self.collectionView-|,
            0
        )
        
        self.extendedLayoutIncludesOpaqueBars = true

    }
    
    @objc func refresh() {
        self.viewModel.reloadData()
        if !Environment.isDebug {
            Answers.logCustomEvent(withName: "Reloaded Coins.", customAttributes: nil)
        }
    }
    
    var adapter: ListAdapter? {
        didSet {
            
            guard let adapter = self.adapter else { return }
            
            adapter.collectionView = collectionView
            adapter.dataSource = viewModel
            
            self.viewModel.contentUpdated.observeOn(MainScheduler.instance).subscribe(onNext: { _ in
                self.collectionView.refreshControl?.endRefreshing()
                if let lastUpdate = CoinMarketCapAPI.shared.lastUpdate {
                    self.collectionView.refreshControl?.attributedTitle = NSAttributedString(
                        string: Strings.RefreshControl.lastUpdate +
                            lastUpdate.string(dateStyle: .none, timeStyle: DateFormatter.Style.medium, in: nil)
                    )
                }
                adapter.performUpdates(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
            
        }
    }
    
    func setupCollectionView() {
        
        collectionView.refreshControl = prepareRefreshControl()
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 1)
        
    }
    
}

extension MarketListViewController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController,
                     cell: UICollectionViewCell, at index: Int) {}
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController,
                     cell: UICollectionViewCell, at index: Int) {}
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        if sectionController.isLastSection {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewModel.allCryptos.onNext(true)
            }
        }
        if sectionController.section == 50 {
            self.viewModel.allCryptos.onNext(false)
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {}
    
}
