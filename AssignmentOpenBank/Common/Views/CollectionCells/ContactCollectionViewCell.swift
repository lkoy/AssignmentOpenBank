//
//  ContactCollectionViewCell.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 17/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit

public final class ContactCollectionViewCell: UICollectionViewCell {
    
    public class var cellIdentifier: String { return "contactCollectionViewCell.identifier" }
    
    private enum ViewTraits {
        static let labelMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        static let imageMargins = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        static let imageSize: CGFloat = 50
    }
    
    private let userImageView: RoundImageView = {
        let imageView = RoundImageView()
        return imageView
    }()
    
    public var contactImage: UIImage? {
        set { userImageView.image = newValue }
        get { return userImageView.image }
    }
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .left
        return lbl
    }()
    public var title: String? {
        set { titleLabel.text = newValue }
        get { return titleLabel.text }
    }
    public var titleColor: UIColor {
        set { titleLabel.textColor = newValue }
        get { return titleLabel.textColor }
    }
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()
    public var subtitle: String? {
        set { subtitleLabel.text = newValue }
        get { return subtitleLabel.text }
    }
    public var subTitleColor: UIColor {
        set { subtitleLabel.textColor = newValue }
        get { return subtitleLabel.textColor }
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .lightGray
        userImageView.contentMode = .scaleAspectFill
        contentView.addSubview(userImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(titleLabel)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.numberOfLines = 1
        contentView.addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTraits.imageMargins.top),
            userImageView.heightAnchor.constraint(equalToConstant: ViewTraits.imageSize),
            userImageView.widthAnchor.constraint(equalToConstant: ViewTraits.imageSize),
            
            titleLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: ViewTraits.labelMargins.top),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.labelMargins.left),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ViewTraits.labelMargins.right),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.labelMargins.left),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ViewTraits.labelMargins.right),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewTraits.labelMargins.top),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTraits.labelMargins.bottom)
            ])
    }
    
    override public func prepareForReuse() {
        
        super.prepareForReuse()
        
        contactImage = nil
        
        title = nil
        titleColor = .black
        
        subtitle = nil
        subTitleColor = .black
    }
}
