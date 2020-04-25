//
//  AccountsTableViewCell.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 30/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

public class AccountsTableViewCell: UITableViewCell {
    
    open class var cellIdentifier: String {
        return "cell.account"
    }
    
    private enum ViewTraits {
        static let containerViewInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        static let containerInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        static let imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        static let innerLabelsSpacing: CGFloat = 5
        static let imageSize: CGFloat = 50
        static let cornerRadius: CGFloat = 10
    }
    
    private let userImageView: RoundImageView = {
        let imageView = RoundImageView()
        return imageView
    }()
    public var leftImage: UIImage? {
        set { userImageView.image = newValue }
        get { return userImageView.image }
    }
    
    private let labelsContainer = UIView()
    
    private let titleLabel: Label = {
        let lbl = Label()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 18)
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
    
    private let subtitleLabel: Label = {
        let lbl = Label()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 13)
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
    
    private let containerView = UIView()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .gray
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .appLigthGrey
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = ViewTraits.cornerRadius
        addSubview(containerView)
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .appWhite
        userImageView.contentMode = .scaleAspectFill
        containerView.addSubview(userImageView)
        
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(labelsContainer)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        labelsContainer.addSubview(titleLabel)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.numberOfLines = 1
        labelsContainer.addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewTraits.containerViewInsets.left),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewTraits.containerViewInsets.right),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: ViewTraits.containerViewInsets.top),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ViewTraits.containerViewInsets.bottom),
            
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewTraits.containerInsets.left),
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ViewTraits.containerInsets.top),
            userImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -ViewTraits.containerInsets.bottom),
            userImageView.heightAnchor.constraint(equalToConstant: ViewTraits.imageSize),
            userImageView.widthAnchor.constraint(equalToConstant: ViewTraits.imageSize),
            
            labelsContainer.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: ViewTraits.imageInsets.left),
            labelsContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewTraits.containerInsets.right),
            labelsContainer.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            labelsContainer.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: ViewTraits.containerInsets.top),
            labelsContainer.bottomAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: -ViewTraits.containerInsets.bottom),
            
            titleLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewTraits.innerLabelsSpacing),
            subtitleLabel.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor),
            ])
    }
    
    public override func prepareForReuse() {
        
        super.prepareForReuse()
        
        leftImage = nil
        
        title = nil
        titleColor = .black
        
        subtitle = nil
        subTitleColor = .black
    }
}
