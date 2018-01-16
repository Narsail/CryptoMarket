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
    
    case flatWhite
    
    case navigationBar
    case navigationBarItems
    
    case backgroundColor
    
    case lightCell
    case whiteCell
    
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
        case .flatWhite:
            return UIColor(hexString: "#EDF1F2")
        case .navigationBar:
//            return Color.logoLightBlue.asUIColor
            return UIColor.white
        case .navigationBarItems:
//            return UIColor(hexString: "#C2E2F0")
            return UIColor.black
        case .lightCell:
//            return Color.logoLightBeige.asUIColor
            return Color.flatWhite.asUIColor
        case .whiteCell:
            return Color.flatWhite.asUIColor
        case .backgroundColor:
//            return Color.logoLightBlue.asUIColor
            return UIColor.white
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

        appearance.shadowImage = UIImage()
//        appearance.setBackgroundImage(UIImage(), for: .default)
//        appearance.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
//        appearance.clipsToBounds = false
        appearance.barTintColor = Color.navigationBar.asUIColor
        appearance.tintColor = Color.navigationBarItems.asUIColor
        appearance.isTranslucent = false
        appearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor : Color.navigationBarItems.asUIColor]
        
        if Environment.isIOS11 {
            if #available(iOS 11.0, *) {
                appearance.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : Color.navigationBarItems.asUIColor]
            }
        }
        
    }
    
}

extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}
