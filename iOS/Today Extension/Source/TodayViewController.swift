//
//  TodayViewController.swift
//  todayextension
//
//  Created by David Moeller on 11.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import UIKit
import NotificationCenter
import RxSwift

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let disposeBag = DisposeBag()
    let coinMarketCapAPI = CoinMarketCapAPI.shared
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = Strings.TodayWidget.title
        }
    }
    @IBOutlet weak var emptyLabel: UILabel! {
        didSet {
            emptyLabel.text = Strings.TodayWidget.empty
        }
    }
    
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        setupData()
    }
    
    func setupData() {
        
        Portfolio.shared.amountUpdated.debounce(1, scheduler: MainScheduler.instance).subscribe(onNext: { amount in
            self.isEmpty(amount == nil)
            if let amount = amount {
                self.dollarLabel.text = "\(amount.usd.string(fractionDigits: 2)) $"
                self.bitcoinLabel.text = "\(amount.btc.string(fractionDigits: 2)) \u{20BF}"
            }
        }).disposed(by: disposeBag)
        
        coinMarketCapAPI.markets.addObserver(owner: self, closure: { resource, _ in
            if let markets: [Cryptocurrency] = resource.typedContent() {
                Portfolio.shared.cryptoUpdate.onNext(markets)
            }
        })
        
        self.reloadData()

    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        self.reloadData()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func isEmpty(_ empty: Bool) {
        self.emptyLabel.isHidden = !empty
        self.dollarLabel.isHidden = empty
        self.bitcoinLabel.isHidden = empty
    }
    
    func reloadData() {
        coinMarketCapAPI.loadAll.onNext(())
    }
    
}
