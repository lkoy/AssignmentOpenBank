//
//  TransactionTableViewCell.swift
//  AssignmentMoneyou
//
//  Created by Iglesias, Gustavo on 24/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import UIKit

public class TransactionTableViewCell: UITableViewCell {
    
    open class var cellIdentifier: String {
        return "cell.transaction"
    }
    
    private enum ViewTraits {
        static let containerInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let innerLabelsSpacing: CGFloat = 10
        static let imageSize: CGFloat = 50
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
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
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
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
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
    
    private let amountLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textAlignment = .right
        return lbl
    }()
    public var amount: String? {
        set { amountLabel.text = newValue }
        get { return amountLabel.text }
    }
    public var amountColor: UIColor {
        set { amountLabel.textColor = newValue }
        get { return amountLabel.textColor }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .lightGray
        userImageView.contentMode = .scaleAspectFill
        addSubview(userImageView)
        
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelsContainer)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        labelsContainer.addSubview(titleLabel)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.numberOfLines = 1
        labelsContainer.addSubview(subtitleLabel)
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.numberOfLines = 1
        amountLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        labelsContainer.addSubview(amountLabel)
        
        setupConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ViewTraits.containerInsets.left),
            userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewTraits.containerInsets.top),
            userImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -ViewTraits.containerInsets.bottom),
            userImageView.heightAnchor.constraint(equalToConstant: ViewTraits.imageSize),
            userImageView.widthAnchor.constraint(equalToConstant: ViewTraits.imageSize),
            
            labelsContainer.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: ViewTraits.innerLabelsSpacing),
            labelsContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ViewTraits.innerLabelsSpacing),
            labelsContainer.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -ViewTraits.innerLabelsSpacing),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewTraits.innerLabelsSpacing),
            subtitleLabel.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor)
            ])
    }
    
    public override func prepareForReuse() {
        
        super.prepareForReuse()
        
        leftImage = nil
        
        title = nil
        titleColor = .black
        
        subtitle = nil
        subTitleColor = .black
        
        amount = nil
        amountColor = .black
        
    }
}
