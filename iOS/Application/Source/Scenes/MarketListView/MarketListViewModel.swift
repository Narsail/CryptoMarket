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
import Crashlytics

class MarketListViewModel: RxSwiftViewModel {
    
    let coinMarketCapAPI = CoinMarketCapAPI.shared
    weak var displayDelegate: ListDisplayDelegate?
    
    var allCryptos = BehaviorSubject<Bool>(value: false)
    
    let cryptosUpdated = PublishSubject<[Cryptocurrency]>()
    var cryptos = [Cryptocurrency]()
    
    var global = BehaviorSubject<Global?>(value: nil)
    var portfolioAmount = BehaviorSubject<PortfolioAmount?>(value: nil)
    let overlay = ResourceStatusOverlay()
    
    let sortToken: NSNumber = 41
    
    var sortOrder = SortOptions.capDescending
    
    // MARK: - Inputs
    let filter = BehaviorSubject<String>(value: "")
    let showSort = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Outputs
    let contentUpdated = PublishSubject<Void>()
    let filtern = PublishSubject<Void>()
    let selectedMarket = PublishSubject<Cryptocurrency>()
    
    override init() {
        
        super.init()
        
        // Bind the Portfolio
        Portfolio.shared.amountUpdated.bind(to: portfolioAmount).disposed(by: disposeBag)
        
        // Load the Markets (actually they are Cryptocurrencies!)
        coinMarketCapAPI.markets.addObserver(owner: self, closure: { [weak self] resource, _ in
            if let markets: [Cryptocurrency] = resource.typedContent() {
                self?.cryptosUpdated.onNext(markets)
                Portfolio.shared.cryptoUpdate.onNext(markets)
            }
        }).addObserver(overlay)
        
        // Bind the Global to the Behavior Subject
        coinMarketCapAPI.global.addObserver(owner: self) { [weak self] resource, _ in
            self?.global.onNext(resource.typedContent())
        }
        
        // Bind the Subjects to the Reload
        Observable.combineLatest(global, portfolioAmount, allCryptos)
            // .debounce(0.5, scheduler: MainScheduler.instance)
            .map({ _ in Void() })
            .bind(to: contentUpdated)
            .disposed(by: disposeBag)
        
        cryptosUpdated
            .do(onNext: { cryptos in
                self.cryptos = self.getSortedCryptos(cryptos: cryptos, with: self.sortOrder)
            })
            .map({ _ in Void() })
            .bind(to: contentUpdated)
            .disposed(by: disposeBag)
        
        showSort
            .map({ _ in Void() })
            .bind(to: contentUpdated)
            .disposed(by: disposeBag)
        
        // Search Text
        self.filter.debounce(0.1, scheduler: MainScheduler.instance).do(onNext: { [unowned self] _ in
            if !Environment.isDebug {
                Answers.logCustomEvent(withName: "Used the Filter.",
                                       customAttributes: ["Filter": (try? self.filter.value()) ?? ""])
            }
            
        }).map { _ in return () }.bind(to: contentUpdated).disposed(by: disposeBag)
        
        // Load directly without debounce. This is necessary due to a bug in the Siesta Overlay View.
        CoinMarketCapAPI.shared.loadAll.onNext(())
        
    }
    
    func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            CoinMarketCapAPI.shared.loadAll.onNext(())
        }
    }
    
    func filterCryptos(cryptos: [Cryptocurrency], with filter: String) -> [Cryptocurrency] {
        
        var cryptos = cryptos
        
        if filter != "" {
            cryptos = cryptos.filter {
                $0.name.lowercased().contains(find: filter.lowercased()) ||
                    $0.symbol.lowercased().contains(find: filter.lowercased())
            }
        }
        
        return cryptos
        
    }
    
    func getSortedCryptos(cryptos: [Cryptocurrency], with order: SortOptions) -> [Cryptocurrency] {
        
        var cryptos = cryptos
        
        switch order {
        case .capAscending:
            cryptos = cryptos.sorted(by: { cryptoOne, cryptoTwo in
                switch (cryptoOne.marketCapUSD, cryptoTwo.marketCapUSD) {
                case (.none, .none):
                    return false
                case (.none, _):
                    return true
                case (.some(let capOneString), .some(let capTwoString)):
                    switch (Double(capOneString), Double(capTwoString)) {
                    case (.none, .none):
                        return false
                    case (.none, _):
                        return true
                    case (.some(let capOne), .some(let capTwo)):
                        return capOne < capTwo
                    default:
                        return false
                    }
                default:
                    return false
                }
                
            })
        case .capDescending:
            cryptos = cryptos.sorted(by: { cryptoOne, cryptoTwo in
                switch (cryptoOne.marketCapUSD, cryptoTwo.marketCapUSD) {
                case (.none, .none):
                    return true
                case (.none, _):
                    return false
                case (.some(let capOneString), .some(let capTwoString)):
                    switch (Double(capOneString), Double(capTwoString)) {
                    case (.none, .none):
                        return true
                    case (.none, _):
                        return false
                    case (.some(let capOne), .some(let capTwo)):
                        return capOne > capTwo
                    default:
                        return true
                    }
                default:
                    return true
                }
                
            })
        case .nameAscending:
            cryptos = cryptos.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
        case .nameDescending:
            cryptos = cryptos.sorted(by: { $0.name.lowercased() > $1.name.lowercased() })
        case .changeAscending:
            cryptos = cryptos.sorted(by: { cryptoOne, cryptoTwo in
                switch (cryptoOne.percentChange24hAmount, cryptoTwo.percentChange24hAmount) {
                case (.none, .none):
                    return false
                case (.none, .some(let change)):
                    return change > 0
                case (.some(let change), .none):
                    return change < 0
                case (.some(let changeOne), .some(let changeTwo)):
                    return changeOne < changeTwo
                }
            })
        case .changeDescending:
            cryptos = cryptos.sorted(by: { cryptoOne, cryptoTwo in
                switch (cryptoOne.percentChange24hAmount, cryptoTwo.percentChange24hAmount) {
                case (.none, .none):
                    return false
                case (.none, .some(let change)):
                    return change < 0
                case (.some(let change), .none):
                    return change > 0
                case (.some(let changeOne), .some(let changeTwo)):
                    return changeOne > changeTwo
                }
            })
        }
        
        return cryptos
        
    }
    
}

extension MarketListViewModel: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        do {
            
            var list = [ListDiffable]()
            
            let filter = ((try? self.filter.value()) ?? "").trimmingCharacters(in: .whitespaces)
            
            // Sort View
            if filter == "", try self.showSort.value() {
                list.append(sortToken)
            }
            
            if filter == "", !(try self.showSort.value()) {
                // Add Portfolio
                if let amount = try self.portfolioAmount.value() {
                    list.append(amount)
                }
                
                // Add Global Data
                if let global = try self.global.value() {
                    list.append(global)
                }
            }
            
            let allCryptos = try self.allCryptos.value()
            
            var filteredCryptos = self.filterCryptos(cryptos: self.cryptos, with: filter)
            
            if !allCryptos, filteredCryptos.count > 100 {
                filteredCryptos = Array(filteredCryptos[0..<100])
            }

            list += filteredCryptos as [ListDiffable]
            
            return list
            
        } catch {
            return []
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case is Cryptocurrency:
            let sectionController = MarketSectionController(delegate: self)
            sectionController.displayDelegate = self.displayDelegate
            return sectionController
        case is Global:
            return GlobalSectionController()
        case is PortfolioAmount:
            return PortfolioAmountSectionController()
        case let sortToken as NSNumber where sortToken == self.sortToken:
            let sectionController = SortSectionController(order: self.sortOrder, delegate: self)
            // sectionController.delegate = self
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

extension MarketListViewModel: MarketSelectionControllerDelegate {
    
    func didSelectItem(_ currency: Cryptocurrency) {
        self.selectedMarket.onNext(currency)
    }
    
}

extension MarketListViewModel: SortCellDelegate {
    
    func didChange(_ sortOrder: SortOptions) {
        if !Environment.isDebug {
            Answers.logCustomEvent(withName: "Used Sorting", customAttributes: ["Option": sortOrder.rawValue])
        }
        self.sortOrder = sortOrder
        self.cryptosUpdated.onNext(self.cryptos)
    }
    
}

enum SortOptions: String {
    case capAscending // Smallest to the Highest
    case capDescending // Highest to the Smallest
    case nameAscending // Beginning with A
    case nameDescending // Beginning with Z
    case changeAscending
    case changeDescending
}
