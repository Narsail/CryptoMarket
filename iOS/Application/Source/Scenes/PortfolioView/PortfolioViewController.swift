//
//  PortfolioViewController.swift
//  CryptoMarket
//
//  Created by David Moeller on 29.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import IGListKit
import Stevia
import Crashlytics

class PortfolioViewController: RxSwiftViewController {
    
    let viewModel: PortfolioViewModel
    
    let collectionView: UICollectionView = {
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        let topInset: CGFloat = 15
        let bottomInset: CGFloat = 0
        
        view.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        view.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        view.alwaysBounceVertical = true
        
        view.backgroundColor = .white
        
        return view
    }()
    
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
    
    init(viewModel: PortfolioViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.displayDelegate = self
        
        // Enable Edit Button if some currencies are shown.
        self.viewModel.portfolioAmount.map {
            $0 != nil
        }.bind(to: self.editButtonItem.rx.isEnabled).disposed(by: disposeBag)

        self.viewModel.editMode.distinctUntilChanged().observeOn(MainScheduler.asyncInstance)
            .do(onNext: { if !$0 { self.setEditing(false, animated: true) } })
            .subscribe().disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        // Background
        self.view.backgroundColor = .white
        
        // Navbar Settings
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if Environment.isIOS11 {
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationItem.largeTitleDisplayMode = .always
                self.navigationItem.title = Strings.NavigationBarItems.portfolio
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
            Answers.logCustomEvent(withName: "Show Portfolio View", customAttributes: nil)
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
    }
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    func setupCollectionView() {
        
        collectionView.refreshControl = prepareRefreshControl()
        
        adapter.collectionView = collectionView
        adapter.dataSource = viewModel
        
        self.viewModel.contentUpdated.observeOn(MainScheduler.instance).subscribe(onNext: { _ in
            self.collectionView.refreshControl?.endRefreshing()
            self.adapter.reloadData(completion: nil)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.filtern.observeOn(MainScheduler.instance).subscribe(onNext: { _ in
            self.adapter.performUpdates(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        self.viewModel.editMode.onNext(editing)
        
    }
    
}

extension PortfolioViewController: ListDisplayDelegate {
    
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
