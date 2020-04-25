//
//  ImageRatio.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit.UIImageView

public enum ImageRatio: CaseIterable {
    case oneToOne
    case twoToOne
    case fourToThree
    case fiveToSix
    case eightToFive
    case sixteenToNine
    
    public var name: String {
        switch self {
        case .oneToOne: return "1:1"
        case .twoToOne: return "2:1"
        case .fourToThree: return "4:3"
        case .eightToFive: return "8:5"
        case .fiveToSix: return "5:6"
        case .sixteenToNine: return "16:9"
        }
    }
    
    public var widthRelation: CGFloat {
        switch self {
        case .oneToOne: return 1
        case .twoToOne: return 2
        case .fourToThree: return 1.33
        case .fiveToSix: return 0.83
        case .eightToFive: return 1.6
        case .sixteenToNine: return 1.78
        }
    }
    
    public var heightRelation: CGFloat {
        switch self {
        case .oneToOne: return 1
        case .twoToOne: return 0.5
        case .fourToThree: return 0.75
        case .fiveToSix: return 1.2
        case .eightToFive: return 0.625
        case .sixteenToNine: return 0.56
        }
    }
}

public class RatioImageView: UIImageView {
    
    public var ratio: ImageRatio! {
        didSet {
            removeConstraint(ratioWidthAnchorContraint)
            ratioWidthAnchorContraint = self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: ratio.widthRelation)
            ratioWidthAnchorContraint.isActive = true
        }
    }
    
    public var cornerRadius: Bool! {
        didSet {
            self.layer.cornerRadius = cornerRadius ? 4 : 0
        }
    }
    
    private var ratioWidthAnchorContraint: NSLayoutConstraint!
    
    public init(ratio: ImageRatio, cornerRadius: Bool) {
        
        super.init(frame: CGRect.zero)
        
        self.ratio = ratio
        self.cornerRadius = cornerRadius
        
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        ratioWidthAnchorContraint = self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: ratio.widthRelation)
        ratioWidthAnchorContraint.isActive = true
        
        self.layer.cornerRadius = cornerRadius ? 4 : 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
