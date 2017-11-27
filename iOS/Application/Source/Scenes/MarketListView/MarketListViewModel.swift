//
//  AppointmentListViewModel.swift
//  SmartNetworkung
//
//  Created by David Moeller on 13.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift
import RxCocoa
import Siesta

class MarketListViewModel: RxSwiftViewModel {
    
    let coinMarketCapAPI = CoinMarketCapAPI.shared
    weak var displayDelegate: ListDisplayDelegate?
    
    var markets: [Market] = []
    var global: Global?
    let overlay = ResourceStatusOverlay()
    let searchToken: NSNumber = 42
    
    // MARK: - Inputs
    let filter = BehaviorSubject<String>(value: "")
    
    // MARK: - Outputs
    let contentUpdated = PublishSubject<Void>()
    let filtern = PublishSubject<Void>()
    let selectedMarket = PublishSubject<(String, String)>()
    
    override init() {
        
        super.init()
        
        // Load the Markets (actually they are Cryptocurrencies!)
        coinMarketCapAPI.markets.addObserver(owner: self, closure: { [weak self] resource, _ in
            
            if let markets: [Market] = resource.typedContent() { self?.markets = markets }
            self?.contentUpdated.onNext(())
            
        }).addObserver(overlay)
        
        coinMarketCapAPI.global.addObserver(owner: self) { [weak self] resource, _ in
            self?.global = resource.typedContent()
            self?.contentUpdated.onNext(())
        }
        
        // Search Text
        self.filter.debounce(0.5, scheduler: MainScheduler.instance)
        .subscribe(onNext: { [unowned self] _ in
                
            self.filtern.onNext(())
                
        }).disposed(by: self.disposeBag)
        
        self.reloadData()
        
    }
    
    func reloadData() {
        coinMarketCapAPI.markets.load()
        coinMarketCapAPI.global.load()
    }
    
}

extension MarketListViewModel: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        var list = [ListDiffable]()
        
        if markets.isEmpty {
            return list
        }
        
        // Add the Title
        list.append("Cryptocurrencies" as NSString)
        
        if let global = self.global {
            list.append(global)
        }
        
        // Search Token
        list.append(searchToken)
        
        let filter = (try? self.filter.value()) ?? ""

        if filter != "" {
            list += (markets.filter {
                $0.name.lowercased().contains(find: filter.lowercased()) ||
                    $0.symbol.lowercased().contains(find: filter.lowercased())
            } as [ListDiffable])
        } else {
            list += (markets as [ListDiffable])
        }
        
        return list
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case is Market:
            return MarketSectionController(delegate: self)
        case is Global:
            return GlobalSectionController()
        case let searchToken as NSNumber where searchToken == self.searchToken:
            let sectionController = SearchSectionController()
            sectionController.delegate = self
            return sectionController
        case is NSString:
            let sectionController = TitleSectionController()
            sectionController.displayDelegate = self.displayDelegate
            return sectionController
        default:
            fatalError("Unknown Object wants Section Contoller")
        }

    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return overlay
    }
    
}

extension MarketListViewModel: SearchSectionControllerDelegate {
    
    func searchSectionController(_ sectionController: SearchSectionController, didChangeText text: String) {
        self.filter.onNext(text)
    }
    
}

extension MarketListViewModel: MarketSelectionControllerDelegate {
    
    func didSelectItem(_ marketIdent: String, and marketName: String) {
        self.selectedMarket.onNext((marketIdent, marketName))
    }
    
}
