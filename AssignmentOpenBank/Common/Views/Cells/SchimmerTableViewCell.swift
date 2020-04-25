//
//  SchimmerTableViewCell.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 04/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit

public class SchimmerTableViewCell: UITableViewCell {
    
    open class var cellIdentifier: String {
        return "cell.schimmer"
    }
    
    private enum ViewTraits {
        static let containerViewInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
        static let containerInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        static let imageInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        static let innerLabelsSpacing: CGFloat = 10
        static let imageSize: CGFloat = 50
        static let labelsSize: CGFloat = 20
        static let cornerRadius: CGFloat = 10
    }
        
    private let labelsContainer = UIView()
    private let userImageView = RoundImageView()
    let shimmerTitleLoader = LoaderView()
    let shimmerSubTitleLoader = LoaderView()
        
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
        userImageView.backgroundColor = .appLigthGrey
        userImageView.image = UIImage(named: "photo_placeholder")
        userImageView.contentMode = .scaleAspectFill
        containerView.addSubview(userImageView)
            
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(labelsContainer)
            
        shimmerTitleLoader.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubview(shimmerTitleLoader)
        shimmerTitleLoader.startShimmering()
            
        shimmerSubTitleLoader.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubview(shimmerSubTitleLoader)
        shimmerSubTitleLoader.startShimmering()
            
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
                
            shimmerTitleLoader.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
            shimmerTitleLoader.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            shimmerTitleLoader.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            shimmerTitleLoader.heightAnchor.constraint(equalToConstant: ViewTraits.labelsSize),
                
            shimmerSubTitleLoader.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            shimmerSubTitleLoader.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            shimmerSubTitleLoader.topAnchor.constraint(equalTo: shimmerTitleLoader.bottomAnchor, constant: ViewTraits.innerLabelsSpacing),
            shimmerSubTitleLoader.heightAnchor.constraint(equalToConstant: ViewTraits.labelsSize),
            shimmerSubTitleLoader.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor),
        ])
    }
        
    public override func prepareForReuse() {
            
        super.prepareForReuse()
        
        userImageView.image = UIImage(named: "photo_placeholder")
    }
}
