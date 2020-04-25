//
//  CarouselAddMoreCollectionViewCell.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 19/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

public final class CarouselAddMoreCollectionViewCell: UICollectionViewCell, Pulseable {
    
    public class var cellIdentifier: String { return "CarouselAddMoreCollectionViewCell.identifier" }
    
    public var pulse: Pulse?
    public var pulseLayer: CALayer? { return pulse?.pulseLayer }
    public var pulseAnimation: PulseAnimation = .none
    
    private var vStackView = UIStackView()
    private var arrowImage = RatioImageView(ratio: .oneToOne, cornerRadius: false)
    private var imageContainer = UIView()
    private var titleLabel = Label(style: .body2)
    
    public var image: UIImage? {
        get { return arrowImage.image }
        set { arrowImage.image = newValue }
    }
    
    public var text: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    private enum ViewTraits {
        static let imageContainerSize = CGSize(width: 48, height: 48)
        static let imageContainerCornerRadius: CGFloat = 4.0
        static let imageSize = CGSize(width: 24, height: 24)
        static let verticalSpacing: CGFloat = 13.0
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        pulse = Pulse(pulseView: self, pulseLayer: vStackView.layer)
        
        imageContainer.backgroundColor = .clear
        imageContainer.layer.cornerRadius = ViewTraits.imageContainerCornerRadius
        imageContainer.layer.borderWidth = 1
        imageContainer.layer.borderColor = UIColor.appMidGrey.cgColor
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(arrowImage)
        
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        vStackView.alignment = .center
        vStackView.distribution = .fillProportionally
        vStackView.axis = .vertical
        vStackView.spacing = ViewTraits.verticalSpacing
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vStackView)
        
        vStackView.addArrangedSubview(imageContainer)
        vStackView.addArrangedSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            arrowImage.heightAnchor.constraint(equalToConstant: ViewTraits.imageSize.height),
            
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor),
            imageContainer.heightAnchor.constraint(equalToConstant: ViewTraits.imageContainerSize.height),
            
            arrowImage.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            arrowImage.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            
            vStackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            vStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            vStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            vStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = contentView.frame.size.width/2.0
    }
    
    override public func prepareForReuse() {
        
        super.prepareForReuse()
        
        image = nil
        text = nil
    }
    
    public override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.vStackView.alpha = self.isHighlighted ? 0.6 : 1.0
            }
        }
    }
    
    // MARK: - Touches
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        defer { super.touchesBegan(touches, with: event) }
        
        guard let touch = touches.first else { return }
        pulse?.start(centre: touch.location(in: self))
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        pulse?.stop()
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesCancelled(touches, with: event)
        
        pulse?.stop()
    }
    
}
