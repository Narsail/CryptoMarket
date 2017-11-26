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
        
        coinMarketCapAPI.markets.addObserver(owner: self, closure: { [weak self] resource, _ in
            
            if let markets: [Market] = resource.typedContent() {
            
                self?.markets = markets
                
            }
            
            self?.contentUpdated.onNext(())
            
        }).addObserver(overlay)
        
        // Search Text
        self.filter.debounce(0.5, scheduler: MainScheduler.instance)
        .subscribe(onNext: { [unowned self] _ in
                
            self.filtern.onNext(())
                
        }).disposed(by: self.disposeBag)
        
        self.reloadData()
        
    }
    
    func reloadData() {
        coinMarketCapAPI.markets.load()
    }
    
}

extension MarketListViewModel: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        if markets.isEmpty {
            return []
        }
        
        let filter = (try? self.filter.value()) ?? ""
        
        if filter != "" {
            return ["Cryptos" as NSString] + [searchToken] + markets.filter {
                $0.name.lowercased().contains(find: filter.lowercased())
            }
        }
        
        return ["Cryptos" as NSString] + [searchToken] + markets
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case let searchToken as NSNumber where searchToken == self.searchToken:
            let sectionController = SearchSectionController()
            sectionController.delegate = self
            return sectionController
        case is NSString:
            let sectionController = TitleSectionController()
            sectionController.displayDelegate = self.displayDelegate
            return sectionController
        default:
            return MarketSectionController(delegate: self)
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
