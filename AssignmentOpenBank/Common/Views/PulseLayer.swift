//
//  PulseLayer.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 11/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

public enum PulseAnimation {
    case none
    case centreTouchRadial
    case centreTouchRadialBeyondBounds
    case centre
    case centreBeyondBounds
    case centreSmall
}

public protocol Pulseable {
    
    var pulse: Pulse? { get }
    
    var pulseLayer: CALayer? { get }
    
    var pulseAnimation: PulseAnimation { get set }
    
}

public struct Pulse {
    
    ///The view upon which the pulses will appear
    fileprivate weak var pulseView: (UIView & Pulseable)?
    
    /// The layer the pulse layers are added to.
    internal weak var pulseLayer: CALayer?
    
    public var animation: PulseAnimation {
        return pulseView?.pulseAnimation ?? .none
    }
    
    /// Pulse layers.
    fileprivate var layers: [InkWellPrivate] = []
    
    public var tint: UIColor = UIColor.appBlack
    
    public var opacity: CGFloat = 0.16

    /**
     An initializer that takes a given view and pulse layer.
     - Parameter pulseView: An optional UIView.
     - Parameter pulseLayer: An optional CALayer.
     */
    public init(pulseView: (UIView & Pulseable)?, pulseLayer: CALayer?) {
        self.pulseView = pulseView
        self.pulseLayer = pulseLayer
    }
    
    fileprivate mutating func removeFirstLayer() {
        layers.removeFirst()
        
    }
    
    mutating func clean() {
        self.pulseLayer?.sublayers?.removeAll(where: { $0 is InkWellPrivate })
    }
    
    mutating func stop(animated: Bool = true) {
        if layers.count == 0 { return }
        let layer = layers.removeFirst()
        if !animated {
            layer.removeFromSuperlayer()
            return
        }
        layer.stop()
    }
    
    mutating func start(centre: CGPoint) {
        
        guard let pulseLayer = pulseLayer else {
            return
        }
        
        let clone = InkWellPrivate()
        clone.tint = tint.withAlphaComponent(opacity)
        pulseLayer.insertSublayer(clone, at: 0)
        layers.append(clone)
        
        switch animation {
        case .none: break
        case .centreBeyondBounds, .centre, .centreSmall:
            clone.start(centre: CGPoint(x: pulseLayer.bounds.width / 2.0, y: pulseLayer.bounds.height / 2.0), animation: animation)
        case .centreTouchRadial, .centreTouchRadialBeyondBounds:
            clone.start(centre: centre, animation: animation)
        }
    }
    
}

private class InkWellPrivate: CALayer {
    
    private var superBounds: CGRect!
    private var location: CGPoint!
    private var toSize: CGFloat {
        let target = max (
            max(location.x, superBounds.width - location.x),
            max(location.y, superBounds.height - location.y)
        )
        switch animation {
        case .none, .centreTouchRadialBeyondBounds, .centreBeyondBounds:
            return max(superBounds.width, superBounds.height) * 3.0
        case .centreSmall:
            return target * 3.0
        case .centreTouchRadial, .centre:
            return target * 5.5
        }
    }
    
    private var toRadius: CGFloat {
        return (toSize / 2)
    }
    
    private var animation: PulseAnimation = .none
    
    private var animGroupIn: CAAnimationGroup {
        let animG = CAAnimationGroup()
        animG.autoreverses = false
        animG.isRemovedOnCompletion = false
        animG.fillMode = CAMediaTimingFillMode.forwards
        animG.animations = [CABasicAnimation.anim(toValue: toSize, key: "bounds.size.width"),
                            CABasicAnimation.anim(toValue: toSize, key: "bounds.size.height"),
                            CABasicAnimation.anim(toValue: toRadius, key: "cornerRadius")]
        return animG
    }
    
    func stop() {
        CATransaction.begin()
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = opacity
        fade.toValue = 0
        fade.fillMode = .forwards
        fade.isRemovedOnCompletion = false
        fade.autoreverses = false
        fade.beginTime = CACurrentMediaTime() + 0.15
        fade.duration = 0.2
        CATransaction.setCompletionBlock({ [weak self] in
            self?.removeFromSuperlayer()
        })
        add(fade, forKey: nil)
        CATransaction.commit()
    }
    
    var tint: UIColor {
        get {
            return UIColor(cgColor: backgroundColor ?? UIColor.clear.cgColor)
        }
        set(color) {
            backgroundColor = color.cgColor
        }
    }
    
    init(with frame: CGRect = .zero) {
        super.init()
        commonInit()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        tint = UIColor.black.withAlphaComponent(0.5)//shellWhite.withAlphaComponent(0.3)
    }
    
    fileprivate func start(centre: CGPoint, animation: PulseAnimation) {
        self.animation = animation
        switch animation {
        case .none: startNoAnimation()
        case .centreTouchRadial, .centre, .centreSmall:
            superlayer?.masksToBounds = true
        case .centreTouchRadialBeyondBounds, .centreBeyondBounds:
            superlayer?.masksToBounds = false
        }
        startAnimationCentred(at: centre)
    }
    
    private func startNoAnimation() {
        // Do Nothing
    }
    
    private func startAnimationCentred(at point: CGPoint) {
        guard let superlayer = superlayer else {
            return
        }
        location = point
        superBounds = superlayer.bounds
        
        let initialFrame = CGRect(x: point.x, y: point.y, width: 0.0, height: 0.0)
        frame = initialFrame
        
        add(animGroupIn, forKey: "bounds")
    }
}

fileprivate extension CABasicAnimation {
    
    static func anim(fromValue: Any? = nil, toValue: Any, key: String, duration: CFTimeInterval = 0.6) -> CAAnimation {
        
        let animation: CABasicAnimation = CABasicAnimation.init(keyPath: key)
        animation.duration = duration
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.fromValue = fromValue
        animation.toValue = toValue
        return animation
        
    }
    
}
