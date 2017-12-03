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
    
    var cryptos = BehaviorSubject<[Cryptocurrency]>(value: [])
    var global = BehaviorSubject<Global?>(value: nil)
    var portfolioAmount = BehaviorSubject<PortfolioAmount?>(value: nil)
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
        
        // Bind the Portfolio
        Portfolio.shared.amountUpdated.bind(to: portfolioAmount).disposed(by: disposeBag)
        
        // Load the Markets (actually they are Cryptocurrencies!)
        coinMarketCapAPI.markets.addObserver(owner: self, closure: { [weak self] resource, _ in
            if let markets: [Cryptocurrency] = resource.typedContent() {
                self?.cryptos.onNext(markets)
                Portfolio.shared.cryptoUpdate.onNext(markets)
            }
        }).addObserver(overlay)
        
        // Bind the Global to the Behavior Subject
        coinMarketCapAPI.global.addObserver(owner: self) { [weak self] resource, _ in
            self?.global.onNext(resource.typedContent())
        }
        
        // Bind the Subjects to the Reload
        Observable.combineLatest(cryptos, global, portfolioAmount)
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map({ _ in Void() })
            .do(onNext: { _ in self.coinMarketCapAPI.markets.removeObservers(ownedBy: self.overlay) })
            .bind(to: contentUpdated)
            .disposed(by: disposeBag)
        
        // Search Text
        self.filter.debounce(0.1, scheduler: MainScheduler.instance)
        .subscribe(onNext: { [unowned self] _ in
            self.filtern.onNext(())
        }).disposed(by: self.disposeBag)
        
        self.reloadData()
        
    }
    
    func reloadData() {
        CoinMarketCapAPI.shared.loadAll.onNext(())
    }
    
}

extension MarketListViewModel: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        do {
            
            var list = [ListDiffable]()
            
            if try cryptos.value().isEmpty {
                return list
            }
            
            // Add the Title
            list.append("Cryptocurrencies" as NSString)
            
            // Add Portfolio
            if let amount = try self.portfolioAmount.value() {
                list.append(amount)
            }
            
            // Add Global Data
            if let global = try self.global.value() {
                list.append(global)
            }
            
            // Search Token
            list.append(searchToken)
            
            let filter = (try? self.filter.value()) ?? ""
            
            if filter != "" {
                list += (try cryptos.value().filter {
                    $0.name.lowercased().contains(find: filter.lowercased()) ||
                        $0.symbol.lowercased().contains(find: filter.lowercased())
                    } as [ListDiffable])
            } else {
                list += (try cryptos.value() as [ListDiffable])
            }
            
            return list
            
        } catch {
            return []
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case is Cryptocurrency:
            return MarketSectionController(delegate: self)
        case is Global:
            return GlobalSectionController()
        case is PortfolioAmount:
            return PortfolioAmountSectionController()
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
