//
//  CALayer+Sketch.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 11/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

public extension CALayer {
    
    enum Shadow: String, CaseIterable {
        case dp1
        case dp2
        case dp3
        case dp4
        case dp6
        case dp8
        case dp9
        case dp12
        case dp16
        case dp24
        
        struct Config {
            let color: UIColor
            let alpha: Float
            let x: CGFloat
            let y: CGFloat
            let blur: CGFloat
            let spread: CGFloat
        }
        
        var config: Config {
            switch self {
            case .dp1:
                return Config(color: UIColor.appBlack, alpha: 0.4, x: 0, y: 1, blur: 2, spread: 0)
            case .dp2:
                return Config(color: UIColor.appBlack, alpha: 0.4, x: 0, y: 2, blur: 4, spread: 0)
            case .dp3:
                return Config(color: UIColor.appBlack, alpha: 0.4, x: 0, y: 2, blur: 6, spread: 0)
            case .dp4:
                return Config(color: UIColor.appBlack, alpha: 0.4, x: 0, y: 2, blur: 8, spread: 0)
            case .dp6:
                return Config(color: UIColor.appBlack, alpha: 0.4, x: 0, y: 4, blur: 10, spread: 0)
            case .dp8:
                return Config(color: UIColor.appBlack, alpha: 0.4, x: 0, y: 4, blur: 12, spread: 0)
            case .dp9:
                return Config(color: UIColor.appBlack, alpha: 0.4, x: 0, y: 5, blur: 14, spread: 0)
            case .dp12:
                return Config(color: UIColor.appBlack, alpha: 0.4, x: 0, y: 7, blur: 17, spread: 1)
            case .dp16:
                return Config(color: UIColor.appBlack, alpha: 0.4, x: 0, y: 9, blur: 22, spread: 0)
            case .dp24:
                return Config(color: UIColor.appBlack, alpha: 0.4, x: 0, y: 10, blur: 38, spread: 2)
            }
        }
    }
    
    private func applySketchShadow(
        color: UIColor = UIColor.appBlack,
        alpha: Float = 0.4,
        x: CGFloat = 0,
        y: CGFloat = 1,
        blur: CGFloat = 2,
        spread: CGFloat = 0) {
        
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func applyShadow(_ shadow: Shadow) {
        
        let config = shadow.config
        applySketchShadow(color: config.color,
                          alpha: config.alpha,
                          x: config.x,
                          y: config.y,
                          blur: config.blur,
                          spread: config.spread)
        
    }
    
    func removeShadow() {
        shadowColor = nil
        shadowOpacity = 0
    }
    
}

