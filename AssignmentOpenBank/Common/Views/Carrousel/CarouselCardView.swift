//
//  CarouselCardView.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 19/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

public final class CarouselCardView: UIView {
    
    private enum ViewTraits {
        static let margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let labelBoxMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let titleMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        static let subtitleMargins = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        static let titleLoaderMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let subtitleLoaderMargins = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 64)
        static let loaderHeight: CGFloat = 30
        static let textContainerMinHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 6
        static let offerActivationTop: CGFloat = 16
    }
    
    private let contentView = UIView()
    private let textContainer = UIView()
    private let imageView = UIImageView()
    private let titleLabel = Label(style: .heading4)
    private let subtitleLabel = Label(style: .body2)
    private let overlayView = UIView()
    private let titleLoader = LoaderView()
    private let subtitleLoader = LoaderView()
    
    public var image: UIImage? {
        set { imageView.image = newValue }
        get { return imageView.image }
    }
    
    public var color: UIColor? {
        set { imageView.backgroundColor = newValue }
        get { return imageView.backgroundColor }
    }
    
    public var title: String? {
        set { titleLabel.text = newValue }
        get { return titleLabel.text }
    }
    public var titleAccessibilityIdentifier: String? {
        set { titleLabel.accessibilityIdentifier = newValue }
        get { return titleLabel.accessibilityIdentifier }
    }
    
    public var subtitle: String? {
        set {
            subtitleLabel.text = newValue ?? ""
        }
        get { return subtitleLabel.text }
    }
    
    public var subtitleNumberOfLines: Int {
        set { subtitleLabel.numberOfLines = newValue }
        get { return subtitleLabel.numberOfLines }
    }
    
    public var subtitleAccessibilityIdentifier: String? {
        set { subtitleLabel.accessibilityIdentifier = newValue }
        get { return subtitleLabel.accessibilityIdentifier }
    }
    
    public var isLoading: Bool = false {
        didSet {
            titleLabel.alpha = isLoading ? 0 : 1
            subtitleLabel.alpha = isLoading ? 0 : 1
            if isLoading {
                titleLoader.startShimmering()
                subtitleLoader.startShimmering()
            } else {
                titleLoader.stopShimmering()
                subtitleLoader.stopShimmering()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        layer.cornerRadius = ViewTraits.cornerRadius
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = ViewTraits.cornerRadius
        addSubview(contentView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .appBlue
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor(white: 0.0, alpha: 0.04)
        contentView.addSubview(overlayView)
        
        textContainer.translatesAutoresizingMaskIntoConstraints = false
        textContainer.backgroundColor = .clear
        textContainer.setContentHuggingPriority(.required, for: .vertical)
        textContainer.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addSubview(textContainer)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.labelColor = .appWhite
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 1
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        textContainer.addSubview(titleLabel)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.labelColor = .appWhite
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.numberOfLines = 1
        subtitleLabel.setContentHuggingPriority(.required, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        textContainer.addSubview(subtitleLabel)
        
        titleLoader.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLoader)
        
        subtitleLoader.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLoader)
        
        setupConstraints()
    }
    
    override public func layoutSubviews() {
        
        super.layoutSubviews()
        layer.applyShadow(.dp1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewTraits.margins.left),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewTraits.margins.right),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: ViewTraits.margins.top),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ViewTraits.margins.bottom),
            
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: textContainer.topAnchor),
            
            textContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: ViewTraits.titleMargins.left),
            titleLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor, constant: -ViewTraits.titleMargins.right),
            titleLabel.topAnchor.constraint(equalTo: textContainer.topAnchor, constant: ViewTraits.titleMargins.top),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: ViewTraits.titleMargins.bottom),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: ViewTraits.subtitleMargins.left),
            subtitleLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor, constant: -ViewTraits.subtitleMargins.right),
            subtitleLabel.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: -ViewTraits.subtitleMargins.bottom),
            
            titleLoader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.titleLoaderMargins.left),
            titleLoader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTraits.titleLoaderMargins.right),
            titleLoader.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ViewTraits.titleLoaderMargins.top),
            titleLoader.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: ViewTraits.titleMargins.bottom),
            
            subtitleLoader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.subtitleLoaderMargins.left),
            subtitleLoader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTraits.subtitleLoaderMargins.right),
            subtitleLoader.topAnchor.constraint(equalTo: titleLoader.bottomAnchor, constant: ViewTraits.subtitleLoaderMargins.top),
            subtitleLoader.bottomAnchor.constraint(lessThanOrEqualTo: textContainer.bottomAnchor, constant: -ViewTraits.subtitleMargins.bottom)
            ])
    }
    
    // MARK: - Image
    
//    public func setImage(_ image: UIImage?, animation: UIImageView.Animation = .fade) {
//
//        if image != nil || imageRatio != nil {
//            textContainerTopConstraint.isActive = true
//        } else {
//            textContainerTopConstraint.isActive = false
//        }
//        layoutIfNeeded()
//
//        if let image = image, animation == .fade {
//            UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
//                self.imageView.image = image
//            }, completion: nil)
//        } else {
//            imageView.image = image
//        }
//    }
//
//    public func setImage(_ url: String?, placeholderImage: UIImage? = nil, animation: UIImageView.Animation = .fade) {
//
//        if let url = url {
//            imageView.getImageFrom(url: url, placeholderImage: placeholderImage, animation: animation) { (_) in
//                self.textContainerTopConstraint.isActive = (self.imageView.image != nil || self.imageRatio != nil) ? true : false
//                self.layoutIfNeeded()
//            }
//        } else {
//            imageView.image = placeholderImage
//        }
//    }
//
//    public func setImage(_ url: URL?, placeholderImage: UIImage? = nil, animation: UIImageView.Animation = .fade) {
//
//        setImage(url?.absoluteString, placeholderImage: placeholderImage, animation: animation)
//    }
//
//    public func setSubtitleMaxLines(_ lines: Int) {
//
//        subtitleLabel.numberOfLines = lines
//    }
}
