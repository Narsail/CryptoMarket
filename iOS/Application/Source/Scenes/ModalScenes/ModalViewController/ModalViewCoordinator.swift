//
//  ModalViewCoordinator.swift
//  CryptoMarket
//
//  Created by David Moeller on 02.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum ModalViewCoordinatorResultType<T> {
    case dismissedWithoutResult
    case dismissedWithResult(result: T)
}

class ModalViewCoordinator<T>: BaseCoordinator<ModalViewCoordinatorResultType<T>> {
    
    private let rootViewController: UIViewController
    private let presentableViewController: ModalPresentedViewController<T>
    private let modalTransitionDelegate = ModalTransitionDelegate(type: .regular)
    
    init(rootViewController: UIViewController, modelPresentableViewController: ModalPresentedViewController<T>) {
        self.rootViewController = rootViewController
        self.presentableViewController = modelPresentableViewController
    }
    
    override func start() -> Observable<ModalViewCoordinatorResultType<T>> {
        
        let modalViewModel = ModalViewViewModel()
        let modalViewController = ModalViewController(
            childViewController: presentableViewController,
            viewModel: modalViewModel
        )
        
        modalViewController.transitioningDelegate = self.modalTransitionDelegate
        modalViewController.modalPresentationStyle = .overFullScreen
        // modalViewController.modalPresentationCapturesStatusBarAppearance = true
        
        rootViewController.present(modalViewController, animated: true, completion: nil)
        
        let resultObservable = presentableViewController.dismiss.map {
            ModalViewCoordinatorResultType.dismissedWithResult(result: $0)
        }
        
        let modalDismiss = modalViewModel.dismiss.map { _ in
            ModalViewCoordinatorResultType<T>.dismissedWithoutResult
        }
        
        return Observable.merge(resultObservable, modalDismiss).do(onNext: { _ in
            modalViewController.dismiss(animated: true, completion: nil)
        })
        
    }
    
}
