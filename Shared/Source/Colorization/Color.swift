//
//  Color.swift
//  CryptoMarket
//
//  Created by David Moeller on 15.12.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

import Foundation
import UIKit

enum Color {
    
    // Logo Colours
    case logoLightBlue
    case logoLightBeige
    
    case navigationBar
    case navigationBarItems
    
    case lightCell
    
    case custom(hexString: String, alpha: Double)
    
}

extension Color {
    
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.asUIColor.withAlphaComponent(CGFloat(alpha))
    }
    
}

extension Color {
    
    var asUIColor: UIColor {
        
        switch self {
        case .logoLightBlue:
            return UIColor(hexString: "#60a1bc")
        case .logoLightBeige:
            return UIColor(hexString: "#dce3cb")
        case .navigationBar:
            return Color.logoLightBlue.asUIColor
        case .navigationBarItems:
            return UIColor(hexString: "#C2E2F0")
        case .lightCell:
            return Color.logoLightBeige.asUIColor
        case .custom(let hexValue, let opacity):
            return UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
//        default:
//            return UIColor.clear
        }
        
    }
}

struct ColorManager {
    
    static func applyColorToNavBar(color: Color) {
        
        let appearance = UINavigationBar.appearance()
        
        appearance.barTintColor = Color.navigationBar.asUIColor
        appearance.isTranslucent = true
        appearance.shadowImage = UIImage()
        appearance.tintColor = Color.navigationBarItems.asUIColor
        appearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor : Color.navigationBarItems.asUIColor]
        
        if Environment.isIOS11 {
            if #available(iOS 11.0, *) {
                appearance.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : Color.navigationBarItems.asUIColor]
            }
        }
        
    }
    
}
