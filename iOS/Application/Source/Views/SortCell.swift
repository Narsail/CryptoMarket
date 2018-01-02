//
//  SortCell.swift
//  CryptoMarket
//
//  Created by David Moeller on 03.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import Stevia
import IGListKit
import RxSwift
import RxCocoa

protocol SortCellDelegate: class {
    func didChange(_ sortOrder: SortOptions)
}

class SortCell: CellWithRoundBorders {
    
    let titleLabel = UILabel()
    
    let capButton = UIButton()
    let capArrow = UIImageView()
    
    let nameButton = UIButton()
    let nameArrow = UIImageView()
    
    let changeButton = UIButton()
    let changeArrow = UIImageView()
    
    weak var delegate: SortCellDelegate?
    let disposeBag = DisposeBag()
    
    private var sortOrder: SortOptions = .capDescending
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupButtonFunctionality()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
        setupButtonFunctionality()
    }
    
    func setupLayout() {
        
        self.backgroundColor = UIColor.flatWhite
        
        // Title Label
        titleLabel.style(Labels.bodyMedium)
        titleLabel.text = Strings.SortCell.title
        
        let arrowHeight: CGFloat = 20
        let arrowWidth: CGFloat = 20
        
        capButton.style(Buttons.normalWhite)
        nameButton.style(Buttons.normalWhite)
        changeButton.style(Buttons.normalWhite)
        
        capButton.setTitle(Strings.SortCell.cap, for: .normal)
        nameButton.setTitle(Strings.SortCell.name, for: .normal)
        changeButton.setTitle(Strings.SortCell.change, for: .normal)
        
        capArrow.image = #imageLiteral(resourceName: "long-arrow-pointing-up")
        nameArrow.image = #imageLiteral(resourceName: "long-arrow-pointing-up")
        changeArrow.image = #imageLiteral(resourceName: "long-arrow-pointing-up")
        
        self.sv(
            titleLabel,
            capButton, capArrow,
            nameButton, nameArrow,
            changeButton, changeArrow
        )
        self.layout(
            20,
            titleLabel.centerHorizontally(),
            10,
            |-40-self.capButton-10-capArrow.height(arrowHeight).width(arrowWidth)-20-|,
            10,
            |-40-self.nameButton-10-nameArrow.height(arrowHeight).width(arrowWidth)-20-|,
            10,
            |-40-self.changeButton-10-changeArrow.height(arrowHeight).width(arrowWidth)-20-|,
            >=20
        )
    }
    
    func setupButtonFunctionality() {
        
        self.capButton.rx.tap.subscribe(onNext: { _ in
            switch self.sortOrder {
            case .capAscending:
                self.didChangeOrder(.capDescending)
            default:
                self.didChangeOrder(.capAscending)
            }
        }).disposed(by: disposeBag)
        
        self.nameButton.rx.tap.subscribe(onNext: { _ in
            switch self.sortOrder {
            case .nameAscending:
                self.didChangeOrder(.nameDescending)
            default:
                self.didChangeOrder(.nameAscending)
            }
        }).disposed(by: disposeBag)
        
        self.changeButton.rx.tap.subscribe(onNext: { _ in
            switch self.sortOrder {
            case .changeAscending:
                self.didChangeOrder(.changeDescending)
            default:
                self.didChangeOrder(.changeAscending)
            }
        }).disposed(by: disposeBag)
        
    }
    
    func didChangeOrder(_ order: SortOptions) {
        self.setOrder(order: order)
        self.delegate?.didChange(order)
    }
    
    func setOrder(order: SortOptions) {
        
        self.sortOrder = order
        
        self.capArrow.isHidden = true
        self.nameArrow.isHidden = true
        self.changeArrow.isHidden = true
        
        switch order {
        case .capAscending:
            self.capArrow.isHidden = false
            self.capArrow.image = #imageLiteral(resourceName: "down-arrow")
        case .capDescending:
            self.capArrow.isHidden = false
            self.capArrow.image = #imageLiteral(resourceName: "long-arrow-pointing-up")
        case .nameAscending:
            self.nameArrow.isHidden = false
            self.nameArrow.image = #imageLiteral(resourceName: "down-arrow")
        case .nameDescending:
            self.nameArrow.isHidden = false
            self.nameArrow.image = #imageLiteral(resourceName: "long-arrow-pointing-up")
        case .changeAscending:
            self.changeArrow.isHidden = false
            self.changeArrow.image = #imageLiteral(resourceName: "down-arrow")
        case .changeDescending:
            self.changeArrow.isHidden = false
            self.changeArrow.image = #imageLiteral(resourceName: "long-arrow-pointing-up")
        }
        
    }
}
