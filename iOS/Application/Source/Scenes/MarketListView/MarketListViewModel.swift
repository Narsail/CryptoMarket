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
    
    var cryptos = BehaviorSubject<[Cryptocurrency]>(value: [])
    var global = BehaviorSubject<Global?>(value: nil)
    var portfolioAmount = BehaviorSubject<PortfolioAmount?>(value: nil)
    let overlay = ResourceStatusOverlay()
    
    let searchToken: NSNumber = 42
    let sortToken: NSNumber = 41
    let loadingToken: NSNumber = 40
    
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
            // .debounce(0.5, scheduler: MainScheduler.instance)
            .map({ _ in Void() })
            .bind(to: contentUpdated)
            .disposed(by: disposeBag)
        
        showSort
            .map({ _ in Void() })
            .bind(to: contentUpdated)
            .disposed(by: disposeBag)
        
        // Search Text
        self.filter.debounce(0.1, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] _ in
            if !Environment.isDebug {
                Answers.logCustomEvent(withName: "Used the Filter.",
                                       customAttributes: ["Filter": (try? self.filter.value()) ?? ""])
            }
            self.filtern.onNext(())
        }).disposed(by: self.disposeBag)
        
        self.reloadData()
        
    }
    
    func reloadData() {
        CoinMarketCapAPI.shared.loadAll.onNext(())
    }
    
    func getSortedCryptos(order: SortOptions) throws -> [Cryptocurrency] {
        
        var cryptos = try self.cryptos.value()
        
//        if !cryptos.isEmpty {
//            cryptos = Array(cryptos[0..<10])
//        }
        
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
            break
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
            
            // Add the Title
            if !Environment.isIOS11 {
                list.append(Strings.NavigationBarItems.cryptocurrencies as NSString)
            }
            
            // Sort View
            if try self.showSort.value() {
                list.append(sortToken)
            }
            
            // Search Token
            if !(try cryptos.value().isEmpty) && !Environment.isIOS11 {
                list.append(searchToken)
            }
            
            let filter = ((try? self.filter.value()) ?? "").trimmingCharacters(in: .whitespaces)
            
            if filter != "" {
                list += (try getSortedCryptos(order: self.sortOrder).filter {
                    $0.name.lowercased().contains(find: filter.lowercased()) ||
                        $0.symbol.lowercased().contains(find: filter.lowercased())
                    } as [ListDiffable])
            } else if try self.showSort.value() {
                list += (try getSortedCryptos(order: self.sortOrder) as [ListDiffable])
            } else {
                
                // Add Portfolio
                if let amount = try self.portfolioAmount.value() {
                    list.append(amount)
                }
                
                // Add Global Data
                if let global = try self.global.value() {
                    list.append(global)
                }
                
                list += (try getSortedCryptos(order: self.sortOrder) as [ListDiffable])
                
            }
            
//            if try cryptos.value().isEmpty {
//                // Add Loading View
//                list.append(loadingToken)
//            }
            
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
        case let sortToken as NSNumber where sortToken == self.sortToken:
            let sectionController = SortSectionController(order: self.sortOrder, delegate: self)
            // sectionController.delegate = self
            return sectionController
        case let loadingToken as NSNumber where loadingToken == self.loadingToken:
            let sectionController = LoadingSectionController()
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

extension MarketListViewModel: SearchSectionControllerDelegate {
    
    func searchSectionController(_ sectionController: SearchSectionController, didChangeText text: String) {
        self.filter.onNext(text)
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
        self.contentUpdated.onNext(())
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
