//
//  CarouselCardView.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 13/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

public final class ImageCardView: UIView {
    
    public enum SaturationType {
        case normal
        case high
        
        public var color: UIColor {
            switch self {
            case .normal: return .appMidGrey
            case .high: return .appDarkGrey
            }
        }
    }
    
    private enum ViewTraits {
        static let margins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        static let cornerRadius: CGFloat = 10
    }
    
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let overlayView = UIView()
    
    public var image: UIImage? {
        set { setImage(newValue) }
        get { return imageView.image }
    }
    
    public var saturationType: SaturationType = .normal {
        didSet {
            overlayView.backgroundColor = saturationType.color
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.cornerRadius = ViewTraits.cornerRadius
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .appLigthGrey
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = ViewTraits.cornerRadius
        addSubview(contentView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = SaturationType.normal.color
        contentView.addSubview(overlayView)
        
        setupConstraints()
    }
    
    override public func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.removeShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.margins.left),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTraits.margins.right),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTraits.margins.top),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTraits.margins.bottom),
            
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            ])
    }
    
    // MARK: - Image
    
    public func setImage(_ image: UIImage?) {
        
        imageView.image = image
    }
}
