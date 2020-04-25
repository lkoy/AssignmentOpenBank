//
//  LoaderView.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 11/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

public class LoaderView: UIView {
    
    private var gradientLayer: CAGradientLayer?
    private var isAnimating: Bool = false
    private var gradientView = UIView()
    
    private var needsRestart: Bool = false
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        isHidden = false
        layer.cornerRadius = 4
        backgroundColor = .clear
        clipsToBounds = true
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gradientView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appComeFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    override public func layoutSubviews() {
        
        super.layoutSubviews()
        
        if isAnimating {
            startShimmering(animated: false, force: true)
        }
    }
    
    public func startShimmering(animated: Bool = true, force: Bool = false) {
        
        if isAnimating && !force && gradientLayer != nil { return }
        isAnimating = true
        
        isHidden = false
        
        let gradientStartPosition: [NSNumber] = [-2.0, -1.0, 0.0, 1.0]
        let gradienEndPosition: [NSNumber] = [0.0, 1.0, 2.0, 3.0]
        
        gradientView.alpha = 0
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = gradientStartPosition
        gradientAnimation.toValue = gradienEndPosition
        gradientAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        gradientAnimation.repeatCount = Float.infinity
        gradientAnimation.duration = 1.0
        
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = bounds
        gradientLayer?.colors = [UIColor.appMidGrey.cgColor, UIColor.appWhite.cgColor, UIColor.appMidGrey.cgColor, UIColor.appWhite.cgColor]
        gradientLayer?.locations = gradientStartPosition
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer?.add(gradientAnimation, forKey: nil)
        gradientView.layer.addSublayer(gradientLayer!)
        
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.gradientView.alpha = 1.0
        }
    }
    
    public func stopShimmering(animated: Bool = true) {
        
        if !isAnimating { return }
        isAnimating = false
        
        UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
            self.gradientView.alpha = 0.0
        }, completion: { (_) in
            //self.isHidden = true
            self.gradientLayer?.removeAllAnimations()
            self.gradientLayer?.removeFromSuperlayer()
            self.gradientLayer = nil
        })
    }
    
    @objc public func appMovedToBackground() {
        needsRestart = isAnimating
        stopShimmering()
    }
    
    @objc public func appComeFromBackground() {
        if needsRestart {
            startShimmering()
        }
    }

}
