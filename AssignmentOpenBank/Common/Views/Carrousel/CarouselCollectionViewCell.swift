//
//  CarouselCollectionViewCell.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 19/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

public final class CarouselCollectionViewCell: UICollectionViewCell {
    
    public class var cellIdentifier: String { return "CarouselCollectionViewCell.identifier" }
    
    private enum ViewTraits {
        static let margins = UIEdgeInsets(top: 10, left: 35, bottom: 10, right: 35)
    }
    
    public let cardView = CarouselCardView()
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.subtitleNumberOfLines = 1
        contentView.addSubview(cardView)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.margins.left),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTraits.margins.right),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTraits.margins.top),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTraits.margins.bottom)
            ])
    }
    
    public func setHighlighted(_ highlighted: Bool, animated: Bool) {

        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.cardView.alpha = highlighted ? 0.8 : 1.0
        }
    }
    
    override public func prepareForReuse() {
        
        super.prepareForReuse()
        
        cardView.isLoading = false
        cardView.image = nil
        cardView.title = nil
        cardView.subtitle = nil
    }
}
