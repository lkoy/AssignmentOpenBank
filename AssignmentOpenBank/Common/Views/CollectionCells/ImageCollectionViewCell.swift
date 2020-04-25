//
//  CarouselCollectionViewCell.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 13/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

public final class ImageCollectionViewCell: UICollectionViewCell {
    
    public class var cellIdentifier: String { return "imageCollectionViewCell.identifier" }
    
    private enum ViewTraits {
        static let margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public let cardView = ImageCardView()
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
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
        
        cardView.image = nil
        cardView.saturationType = .normal
    }
}
