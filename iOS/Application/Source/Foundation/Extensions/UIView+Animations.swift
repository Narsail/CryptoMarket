//
//  UIView+Animations.swift
//  Evomo
//
//  Created by David Moeller on 06.11.17.
//  Copyright © 2017 Evomo. All rights reserved.
//

import UIKit

extension UIView {
    static func spring(_ duration: TimeInterval, delay: TimeInterval, animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        if #available(iOS 10.0, *) {
            UIViewPropertyAnimator.springAnimation(duration, delay: delay, animations: animations, completion: {_ in completion(true) })
        } else {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: animations, completion: completion)
        }
    }
    
    static func spring(_ duration: TimeInterval, animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        if #available(iOS 10.0, *) {
            UIViewPropertyAnimator.springAnimation(duration, animations: animations, completion: {_ in completion(true) })
        } else {
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: animations, completion: completion)
        }
    }
}

@available(iOS 10.0, *)
extension UIViewPropertyAnimator {
    
    static func springAnimation(_ duration: TimeInterval, delay: TimeInterval, animations: @escaping () -> Void, completion: @escaping (UIViewAnimatingPosition) -> Void) {
        let springParameters = UISpringTimingParameters(dampingRatio: 0.7)
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: springParameters)
        animator.addAnimations(animations)
        animator.addCompletion(completion)
        animator.startAnimation(afterDelay: delay)
    }
    
    static func springAnimation(_ duration: TimeInterval, animations: @escaping () -> Void, completion: @escaping (UIViewAnimatingPosition) -> Void) {
        springAnimation(duration, delay: 0.0, animations: animations, completion: completion)
    }
}
