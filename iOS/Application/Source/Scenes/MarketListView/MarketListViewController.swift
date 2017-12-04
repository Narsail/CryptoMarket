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

class MarketListViewController: RxSwiftViewController {

    let viewModel: MarketListViewModel
    
    let collectionView: UICollectionView = {
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        let topInset: CGFloat = 0
        let bottomInset: CGFloat = 0
        
        view.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        view.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        view.alwaysBounceVertical = true
        
        view.backgroundColor = .white
        
        return view
    }()
    
    let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        
        control.tintColor = .gray
        control.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        return control
    }()
    
    init(viewModel: MarketListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.displayDelegate = self
        
        // Sort Icon
        let sortItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "sort"), style: UIBarButtonItemStyle.plain, target: nil, action: nil
        )
        sortItem.tintColor = .black
        
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
            if show && self.collectionView.numberOfSections > 0 {
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
        self.view.backgroundColor = .white
        
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
            Answers.logCustomEvent(withName: "Show Market List View", customAttributes: nil)
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
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    func setupCollectionView() {
        
        collectionView.refreshControl = self.refreshControl
        
        adapter.collectionView = collectionView
        adapter.dataSource = viewModel
        
        self.viewModel.contentUpdated.observeOn(MainScheduler.instance).subscribe(onNext: { _ in
            self.refreshControl.endRefreshing()
            self.adapter.reloadData(completion: nil)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.filtern.observeOn(MainScheduler.instance).subscribe(onNext: { _ in
            self.adapter.performUpdates(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
    }
    
}

extension MarketListViewController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController,
                     cell: UICollectionViewCell, at index: Int) {
        return
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController,
                     cell: UICollectionViewCell, at index: Int) {
        return
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        if sectionController is TitleSectionController {
            self.navigationItem.title = nil
        }
        return
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        if let sectionController = sectionController as? TitleSectionController {
            self.navigationItem.title = sectionController.title
        }
        return
    }
    
}
