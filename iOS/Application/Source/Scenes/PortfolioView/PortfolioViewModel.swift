//
//  PortfolioViewModel.swift
//  CryptoMarket
//
//  Created by David Moeller on 29.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import IGListKit
import RxSwift
import RxCocoa
import Siesta

class PortfolioViewModel: RxSwiftViewModel {
    
    let coinMarketCapAPI = CoinMarketCapAPI.shared
    weak var displayDelegate: ListDisplayDelegate?
    
    var portfolioAmount = BehaviorSubject<PortfolioAmount?>(value: nil)
    let overlay = ResourceStatusOverlay()
    let addToken: NSNumber = 42
    
    // MARK: - Inputs
    let filter = BehaviorSubject<String>(value: "")
    let editMode = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Outputs
    let contentUpdated = PublishSubject<Void>()
    let filtern = PublishSubject<Void>()
    let addPortfolioItem = PublishSubject<Void>()
    
    override init() {
        
        super.init()
        
        // Bind the Portfolio (The Markets will be put into the Portfolio Calculator through the other View Model)
        Portfolio.shared.amountUpdated.do(onNext: {
            if $0 == nil {
                self.editMode.onNext(false)
            }
        }).bind(to: portfolioAmount).disposed(by: disposeBag)
        
        // Bind the Subjects to the Reload
        
        Observable.combineLatest(portfolioAmount, Portfolio.shared.updatedPortfolio)
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map({ _ in Void() })
            .do(onNext: { _ in self.coinMarketCapAPI.markets.removeObservers(ownedBy: self.overlay) })
            .bind(to: contentUpdated)
            .disposed(by: disposeBag)
        
        self.editMode.map { _ in Void() }.bind(to: contentUpdated).disposed(by: disposeBag)
        
        self.reloadData()
        
    }
    
    func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            CoinMarketCapAPI.shared.loadAll.onNext(())
        }
    }
    
    func addToPortfolio(crypto: OwningCryptoCurrency) {
        Portfolio.shared.add(crypto)
        // To calculate the new Amount
        self.reloadData()
    }
    
}

extension PortfolioViewModel: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        do {
            
            var list = [ListDiffable]()
            
            // Add the Title
            if !Environment.isIOS11 {
                list.append(Strings.NavigationBarItems.portfolio as NSString)
            }
            
            // Add Portfolio
            if let amount = try self.portfolioAmount.value() {
                list.append(amount)
            }
            
            // Add Portfolio items
            list += (try Portfolio.shared.updatedPortfolio.value()) as [ListDiffable]
            
            // Add Add Button to the End of the list
            list.append(addToken)
            
            return list
            
        } catch {
            return []
        }
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        switch object {
        case is Global:
            return GlobalSectionController()
        case is OwningCryptoCurrency:
            let sectionController = PortfolioItemSectionController(showDelete: (try? self.editMode.value()) ?? false)
            sectionController.delegate = self
            return sectionController
        case is PortfolioAmount:
            return PortfolioAmountSectionController()
        case let addToken as NSNumber where addToken == self.addToken:
            let sectionController = AddToPortfolioSectionController(delegate: self)
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

extension PortfolioViewModel: SearchSectionControllerDelegate {
    
    func searchSectionController(_ sectionController: SearchSectionController, didChangeText text: String) {
        self.filter.onNext(text)
    }
    
}

extension PortfolioViewModel: AddToPortfolioSelectionControllerDelegate {
    
    func didSelectAddItem() {
        addPortfolioItem.onNext(())
    }
    
}

extension PortfolioViewModel: PortfolioItemDelegate {
    
    func deleteItem(crypto: OwningCryptoCurrency) {
        Portfolio.shared.remove(crypto)
        // To calculate the new Amount
        self.contentUpdated.onNext(())
    }
    
}
