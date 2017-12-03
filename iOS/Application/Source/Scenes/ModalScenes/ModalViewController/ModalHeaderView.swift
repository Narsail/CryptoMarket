//
//  ModalHeaderView.swift
//  Evomo
//
//  Created by David Moeller on 06.11.17.
//  Copyright © 2017 Evomo. All rights reserved.
//
// Inspired by Adrian Corscadden

import UIKit
import Stevia

enum ModalHeaderViewStyle {
    case light
    case dark
}

class ModalHeaderView: UIView {
    
    // MARK: - Public
    var closeCallback: (() -> Void)? {
        didSet { close.tap = closeCallback }
    }
    
    init(title: String, style: ModalHeaderViewStyle) {
        self.style = style
        
        super.init(frame: .zero)
        setupSubviews()
        self.title.text = title
    }
    
    // MARK: - Private
    private let title = UILabel(font: .customBold(size: 17.0))
    private let close = UIButton.close
    private var faq: UIButton?
    private let border = UIView()
    private let buttonSize: CGFloat = 44.0
    private let style: ModalHeaderViewStyle
    
    private func setupSubviews() {
        
        self.sv([title, close, border])
        
        self.layout(
            |-0-close.width(buttonSize).height(buttonSize).centerVertically()
        )
        
        self.layout(
            title.style(Labels.subTitle).centerVertically().centerHorizontally()
        )
        
        // Maybe not with layout
        self.layout(
            0,
            |-0-border.height(1.0)-0-|,
            0
        )
        
        backgroundColor = .white
        
        setColors()
    }
    
    private func setColors() {
        switch style {
        case .light:
            title.textColor = .white
            close.tintColor = .white
            faq?.tintColor = .white
        case .dark:
            border.backgroundColor = UIColor(red: 213.0/255.0, green: 218.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
