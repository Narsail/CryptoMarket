//
//  RatingViewController.swift
//  Evomo
//
//  Created by David Moeller on 06.11.17.
//  Copyright © 2017 Evomo. All rights reserved.
//

import UIKit
import Stevia
import RxSwift
import RxCocoa
import Crashlytics

class AddPortfolioItemViewController: ModalPresentedViewController<OwningCryptoCurrency>, ModalPresentable {
    
    let disposeBag = DisposeBag()
    
    var parentView: UIView? //ModalPresentable
    
    override var modalTitle: String {
        return Strings.AddPortfolioItem.title
    }
    
    let symbolTextfield = UITextField()
    let symbolMark = UIImageView()
    
    let amountTextField = UITextField()
    
    let border: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryBorder
        return view
    }()
    
    let submitButton = UIButton(type: UIButtonType.system)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: .UIKeyboardWillHide, object: nil)
        
        // Add the Add Routine
        // Validate the Symbol
        let symbolIsValid = self.symbolTextfield.rx.text.orEmpty.throttle(0.5, scheduler: MainScheduler.instance)
        .map { input in
            Portfolio.shared.availableCryptos.contains(where: { $0.0 == input || $0.1 == input })
        }.do(onNext: { valid in
            if valid {
                self.symbolMark.image = #imageLiteral(resourceName: "checked")
            } else {
                self.symbolMark.image = #imageLiteral(resourceName: "cancel")
            }
        }).share(replay: 1)
        
        // Validate the Amunt
        let amountIsValid = self.amountTextField.rx.text.orEmpty.throttle(0.5, scheduler: MainScheduler.instance)
        .map { input in
            input.toDouble() != nil
        }.share(replay: 1)
        
        // Enable the Button
        Observable.combineLatest(symbolIsValid, amountIsValid).map { symbol, amount in
            symbol && amount
        }.bind(to: submitButton.rx.isEnabled).disposed(by: disposeBag)
        
        // Dismiss the View with Result
        let portfolioInput = Observable.combineLatest(symbolTextfield.rx.text.orEmpty, amountTextField.rx.text.orEmpty)
        
        submitButton.rx.tap.withLatestFrom(portfolioInput).map { (symbol, amount) -> OwningCryptoCurrency in
            
            if !Environment.isDebug {
                Answers.logCustomEvent(withName: "Added Portfolio Item.", customAttributes: ["Symbol": symbol])
            }
            
            let double = amount.toDouble()!
            
            let index = Portfolio.shared.availableCryptos.index(where: { $0.0 == symbol || $0.1 == symbol })
            
            let (_, cryptoSymbol) = Portfolio.shared.availableCryptos[index!]
            
            return OwningCryptoCurrency(symbol: cryptoSymbol, amount: double)
            
        }.bind(to: self.dismiss).disposed(by: disposeBag)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        
        self.submitButton.isEnabled = false
        
        self.symbolTextfield.placeholder = Strings.AddPortfolioItem.symbol
        self.symbolTextfield.textAlignment = .center
        
        self.amountTextField.placeholder = Strings.AddPortfolioItem.amount
        self.amountTextField.textAlignment = .center
        self.amountTextField.keyboardType = .decimalPad
        
        self.submitButton.style(Buttons.normalBlack)
        self.submitButton.setTitle(Strings.AddPortfolioItem.addButton, for: .normal)
        
        self.view.sv([self.symbolTextfield, symbolMark, amountTextField, self.border, self.submitButton])
        self.view.layout(
            20,
            |-15-self.symbolTextfield-5-symbolMark.height(20)-15-|,
            20,
            |-15-self.amountTextField,
            20,
            |self.border.height(1)|,
            20,
            |-15-self.submitButton.height(50)-15-|,
            20
        )
        
        self.symbolTextfield.Width == self.amountTextField.Width
        self.symbolMark.Height == self.symbolMark.Width
        
    }
    
    func configureButton() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Keyboard Notifications
    @objc private func keyboardWillShow(notification: Notification) {
        copyKeyboardChangeAnimation(notification: notification)
    }

    @objc private func keyboardWillHide(notification: Notification) {
        copyKeyboardChangeAnimation(notification: notification)
    }

    private func copyKeyboardChangeAnimation(notification: Notification) {
        guard let info = KeyboardNotificationInfo(notification.userInfo) else { return }
        UIView.animate(withDuration: info.animationDuration, delay: 0, options: info.animationOptions, animations: {
            guard let parentView = self.parentView else { return }
            parentView.frame = parentView.frame.offsetBy(dx: 0, dy: info.deltaY)
        }, completion: nil)
    }
    
}

struct KeyboardNotificationInfo {
    
    var deltaY: CGFloat {
        return endFrame.minY - startFrame.minY
    }
    var animationOptions: UIViewAnimationOptions {
        return UIViewAnimationOptions(rawValue: animationCurve << 16)
    }
    let animationDuration: Double
    
    init?(_ userInfo: [AnyHashable : Any]?) {
        guard let userInfo = userInfo else { return nil }
        guard let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let startFrame = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
            let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
                return nil
        }
        
        self.endFrame = endFrame.cgRectValue
        self.startFrame = startFrame.cgRectValue
        self.animationDuration = animationDuration.doubleValue
        self.animationCurve = animationCurve.uintValue
    }
    
    private let endFrame: CGRect
    private let startFrame: CGRect
    private let animationCurve: UInt
}
