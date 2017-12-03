//
//  UIButton.swift
//  Evomo
//
//  Created by David Moeller on 06.11.17.
//  Copyright © 2017 Evomo. All rights reserved.
//

import UIKit

extension UIButton {
    
    static var close: UIButton {
        let accessibilityLabel = Environment.isScreenshots ? "Close" : Strings.AccessibilityLabels.close
        return UIButton.icon(image: #imageLiteral(resourceName: "Close"), accessibilityLabel: accessibilityLabel)
    }
    
    static func icon(image: UIImage, accessibilityLabel: String) -> UIButton {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.setImage(image, for: .normal)
        
        if image == #imageLiteral(resourceName: "Close") {
            button.imageEdgeInsets = UIEdgeInsetsMake(14.0, 14.0, 14.0, 14.0)
        } else {
            button.imageEdgeInsets = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0)
        }
        
        button.tintColor = .darkText
        button.accessibilityLabel = accessibilityLabel
        return button
    }
    
}
