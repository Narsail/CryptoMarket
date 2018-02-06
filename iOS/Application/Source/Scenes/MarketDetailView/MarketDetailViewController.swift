//
//  MarketDetailViewController.swift
//  CryptoMarket
//
//  Created by David Moeller on 26.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import Stevia
import RxSwift
import Siesta
import Crashlytics
import Charts

class MarketDetailViewController: RxSwiftViewController {
    
    let viewModel: MarketDetailViewModel
    
    init(viewModel: MarketDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.title = self.viewModel.name
        
        setupViewController()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewController() {
        
        self.view.backgroundColor = .white
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
        
    }
    
    /* Views */
    
    // MARK: - Prime View
    
    let leftPrimaryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatGray
        return view
    }()
    let percentageChangeLabel: UILabel = {
        let label = UILabel()
        label.style(Labels.body)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    let rightPrimaryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatWhite
        return view
    }()
    let rankLabel = UILabel()
    
    // MARK: - Percent Change View
    
    let change1hView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatGray
        return view
    }()
    let change7dView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatGray
        return view
    }()
    let change1h = UILabel()
    let change7d = UILabel()
    
    // MARK: - Information View Part
    
    let informationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatWhite
        return view
    }()
    
    // Loading Indicator
    let overlay = ResourceStatusOverlay()
    
    let symbolLabel = UILabel()
    let marketCapLabel = UILabel()
    
    let priceUSD = UILabel()
    let priceBTC = UILabel()
    
    let volume = UILabel()
    
    // MARK: - Chart View
    
    let chartContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.flatWhite
        return view
    }()
    
    let chartTitleLabel = UILabel()
    let chartView = LineChartView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureUI()
        
        viewModel.marketUpdated.observeOn(MainScheduler.instance).subscribe(onNext: { market in
            self.populateData(market: market)
        }).disposed(by: self.disposeBag)
        
        viewModel.historyDataUpdated.observeOn(MainScheduler.instance).subscribe(onNext: { data in
            self.populateHistoryData(data)
        }).disposed(by: self.disposeBag)
        
        viewModel.marketResource.addObserver(overlay)
        viewModel.reload.onNext(())
        
        // Create Reload Bar Button Item
        let barButtonitem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        self.navigationItem.rightBarButtonItem = barButtonitem
        
        self.navigationController?.view.backgroundColor = Color.backgroundColor.asUIColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !Environment.isDebug {
            Answers.logCustomEvent(withName: "Show Market Detail View", customAttributes: ["coin": self.viewModel.name])
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.leftPrimaryView.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
        self.rightPrimaryView.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
        self.informationView.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
        self.change1hView.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
        self.change7dView.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
        self.chartContainerView.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
    }
    
    func configureUI() {
        
        self.view.sv(self.leftPrimaryView, self.rightPrimaryView, self.informationView, self.change1hView,
                     self.change7dView, chartContainerView)
        
        self.view.layout(
            10,
            |-self.leftPrimaryView.width(100).height(50)-10-self.rightPrimaryView.height(50)-|,
            10,
            |-self.change1hView.height(50)-10-self.change7dView.height(50)-|,
            10,
            |-self.informationView.height(160)-|,
            10,
            |-chartContainerView-|,
            50
        )
        
        let topOffest: CGFloat = 10
        self.leftPrimaryView.Top == topLayoutGuide.Bottom + topOffest
        self.rightPrimaryView.Top == topLayoutGuide.Bottom + topOffest
        
        self.change1hView.Width == self.change7dView.Width
        
        // Left Primary View
        self.leftPrimaryView.sv(self.percentageChangeLabel)
        self.leftPrimaryView.layout(
            |-self.percentageChangeLabel.centerVertically()-|
        )
        
        // Right Primary View
        
        self.rightPrimaryView.sv(self.rankLabel)
        self.rightPrimaryView.layout(
            0,
            |-(>=10)-self.rankLabel-(>=10)-|,
            0
        )
        rankLabel.centerVertically().centerHorizontally()
        
        // percent Change Views
        self.change1hView.sv(change1h)
        self.change7dView.sv(change7d)
        self.change1hView.layout(
            |-self.change1h.centerVertically()-|
        )
        self.change7dView.layout(
            |-self.change7d.centerVertically()-|
        )
        change1h.style(Labels.body)
        change1h.textAlignment = .center
        change7d.style(Labels.body)
        change7d.textAlignment = .center
        
        // Information View
        setupInformationView()
        
        // ChartView
        setupChartView()
        
    }
    
    func setupInformationView() {
        
//        self.informationView.backgroundColor = .clear
        
        self.informationView.sv(overlay)
        self.informationView.layout(
            0,
            |overlay|,
            0
        )
    
        // Symbol and Market Cap
        
        self.informationView.sv(symbolLabel, marketCapLabel)
        
        symbolLabel.Width == marketCapLabel.Width
        
        symbolLabel.style(Labels.body)
        marketCapLabel.style(Labels.body)
        
        // Price USD and Price BTC
        
        self.informationView.sv(priceUSD, priceBTC)
        
        priceUSD.Width == priceBTC.Width
        
        priceUSD.style(Labels.body)
        priceBTC.style(Labels.body)
        
        // Volume
        self.informationView.sv(volume)
        
        volume.style(Labels.body)
        
        // Layout

        self.informationView.layout(
            15,
            |-20-symbolLabel-10-marketCapLabel-20-|,
            15,
            |-20-priceUSD-20-|,
            15,
            |-20-priceBTC-20-|,
            15,
            |-20-volume-20-|,
            >=15
        )
        
    }
    
    func setupChartView() {
        
        self.chartContainerView.sv(chartTitleLabel, chartView)
        
        self.chartContainerView.layout(
            15,
            chartTitleLabel.centerHorizontally(),
            15,
            |-chartView-|,
            15
        )
        
        self.chartTitleLabel.style(Labels.bodyMedium)
        self.chartTitleLabel.text = "Last 6 Months"
        
        self.chartView.noDataFont = UIFont.systemFont(ofSize: 17)
        self.chartView.dragEnabled = false
        self.chartView.setScaleEnabled(false)
        self.chartView.chartDescription?.text = nil
        
        // No Background Grid
        self.chartView.drawGridBackgroundEnabled = false
        
        // Legend Modifications
        self.chartView.legend.enabled = false
        
        // x Axis Modifications
        self.chartView.xAxis.enabled = false
        
        // y Axis Modifications
        self.chartView.leftAxis.enabled = false
        self.chartView.rightAxis.drawGridLinesEnabled = false
        self.chartView.rightAxis.drawZeroLineEnabled = false
        self.chartView.rightAxis.drawAxisLineEnabled = false
        
    }
    
    func populateData(market: CryptoCurrencyExtended) {
        
        self.overlay.isHidden = true
        
        // Percent Change Label 24h
        
        if let percentChange24 = market.percentChange24hAmount {
        
            if percentChange24 == 0.0 {
                self.leftPrimaryView.backgroundColor = UIColor.flatGray
                self.percentageChangeLabel.text = "\(percentChange24.string(fractionDigits: 2))%"
            } else if percentChange24 < 0.0 {
                self.leftPrimaryView.backgroundColor = UIColor.flatRed
                self.percentageChangeLabel.text = "\(percentChange24.string(fractionDigits: 2))%"
            } else {
                self.leftPrimaryView.backgroundColor = UIColor.flatGreen
                self.percentageChangeLabel.text = "+\(percentChange24.string(fractionDigits: 2))%"
            }
        }
        
        // Percent Change Label 1h
        
        if let percentChange = market.percentChange1hAmount {
            
            if percentChange == 0.0 {
                self.change1hView.backgroundColor = UIColor.flatGray
                self.change1h.text = "1h Change: \(percentChange.string(fractionDigits: 2))%"
            } else if percentChange < 0.0 {
                self.change1hView.backgroundColor = UIColor.flatRed
                self.change1h.text = "1h Change: \(percentChange.string(fractionDigits: 2))%"
            } else {
                self.change1hView.backgroundColor = UIColor.flatGreen
                self.change1h.text = "1h Change: +\(percentChange.string(fractionDigits: 2))%"
            }
        }
        
        // Percent Change Label 7d
        
        if let percentChange = market.percentChange7dAmount {
            
            if percentChange == 0.0 {
                self.change7dView.backgroundColor = UIColor.flatGray
                self.change7d.text = "7d Change: \(percentChange.string(fractionDigits: 2))%"
            } else if percentChange < 0.0 {
                self.change7dView.backgroundColor = UIColor.flatRed
                self.change7d.text = "7d Change: \(percentChange.string(fractionDigits: 2))%"
            } else {
                self.change7dView.backgroundColor = UIColor.flatGreen
                self.change7d.text = "7d Change: +\(percentChange.string(fractionDigits: 2))%"
            }
        }
        
        // Set the Rank
        
        self.rankLabel.text = "Rank " + market.rank
        
        // Symbol and Market Cap
        self.symbolLabel.text = "Symbol: " + market.symbol
        self.marketCapLabel.text = "Cap: " + market.formattedMarketCap
        
        // Price USD and BTC
        self.priceUSD.text = "Price: " + (market.priceUSD ?? "0") + " USD"
        self.priceBTC.text = "Price: " + (market.priceBTC ?? "0") + " BTC"
        
        // Volume
        if let volume = market.volume24hUSD {
            self.volume.text = "Volume (24): " + volume + " USD"
        } else {
            self.volume.text = "Volume (24): Unknown"
        }
        
    }
    
    func populateHistoryData(_ historyData: HistoDayResponse) {
        // Line Chart Data
        var lineChartEntry = [ChartDataEntry]()
        
        for dataPoint in historyData.data {
            
            lineChartEntry.append(
                ChartDataEntry(x: Double(dataPoint.time), y: dataPoint.close)
            )
            
        }
        
        let lineOne = LineChartDataSet(values: lineChartEntry, label: nil)
        lineOne.axisDependency = .left
        lineOne.setColor(UIColor.flatBlack)
        lineOne.drawCirclesEnabled = false
        lineOne.lineWidth = 2.0
        
        let lineChartData = LineChartData()
        lineChartData.addDataSet(lineOne)
        
        chartView.data = lineChartData
        
    }
    
    @objc func refresh() {
        self.viewModel.reload.onNext(())
    }
    
}
