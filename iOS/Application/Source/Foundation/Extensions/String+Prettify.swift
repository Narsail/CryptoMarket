//
//  String+Prettify.swift
//  Evomo
//
//  Created by David Moeller on 14.09.17.
//  Copyright © 2017 Evomo. All rights reserved.
//

import Foundation

extension String {
    
    public func prettify() -> String {
        
        // Replace Underscores with Space
        let underscoreLess = self.replacingOccurrences(of: "_", with: " ")
        
        // Uppercase the first chars
        return underscoreLess.capitalized
        
    }
    
    public func localize() -> String {
        return NSLocalizedString(self, comment: "\(self) localized.")
    }
    
}
