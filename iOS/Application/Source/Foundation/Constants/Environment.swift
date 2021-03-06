//
//  Environment.swift
//  SmartNetworking
//
//  Created by David Moeller on 23.11.17.
//  Copyright © 2017 David Moeller. All rights reserved.
//

struct Environment {
    static let isSimulator: Bool = {
        #if arch(i386) || arch(x86_64)
            return true
        #else
            return false
        #endif
    }()
    static let isScreenshots: Bool = {
        #if Screenshots
            return true
        #else
            return false
        #endif
    }()
    
    static let isDebug: Bool = {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }()
    static let isIOS11: Bool = {
        if #available(iOS 11.0, *) {
            return true
        }
        return false
    }()
}
