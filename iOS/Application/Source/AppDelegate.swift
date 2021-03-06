//
//  AppDelegate.swift
//  CryptoMarket
//
//  Created by David Moeller on 19/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit
import RxSwift
import Fabric
import Crashlytics
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Apply Color Schemes
        ColorManager.applyColorToNavBar(color: .navigationBar)
        
        // Override point for customization after application launch.
        let window = UIWindow()
        self.window = window
        
        if Environment.isDebug {
            Fabric.with([Crashlytics.self])
        } else {
            Fabric.with([Crashlytics.self, Answers.self])
        }
        
        // Start the AppCoordinator
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start().subscribe().disposed(by: disposeBag)
        
        // Check for new Version
        Siren.shared.forceLanguageLocalization = .english
        Siren.shared.checkVersion(checkType: .immediately)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Load all Data when the App goes active
        CoinMarketCapAPI.shared.loadAll.onNext(())
        
        Siren.shared.checkVersion(checkType: .daily)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        /*
         Useful if user returns to your app from the background after being sent to the
         App Store, but doesn't update their app before coming back to your app.
         
         ONLY USE WITH Siren.AlertType.immediately
         */
        
        Siren.shared.checkVersion(checkType: .immediately)
    }

}
