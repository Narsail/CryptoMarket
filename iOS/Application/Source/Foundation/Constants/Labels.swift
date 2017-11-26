//
//  Labels.swift
//  CryptoMarket
//
//  Created by David Moeller on 20.11.17.
//  Copyright © 2017 Evomo. All rights reserved.
//

import Foundation
import UIKit

struct Labels {
    
    static func title(label: UILabel) {
        label.font = UIFont.boldSystemFont(ofSize: 35.0)
        label.text = "Title"
    }
    
    static func subTitle(label: UILabel) {
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.text = "Title"
    }
    
    static func graySubTitle(label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = UIColor(red: 0.3137, green: 0.3529, blue: 0.4, alpha: 1.0)
        label.text = "GraySubtitle"
    }
    
    static func body(label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 17)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
    }
    
    static func bodyMedium(label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    static func grayBodySubTitle(label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 0.3137, green: 0.3529, blue: 0.4, alpha: 1.0)
    }
    
}
