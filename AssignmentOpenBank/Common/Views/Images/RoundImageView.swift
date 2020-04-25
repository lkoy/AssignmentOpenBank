//
//  RoundImageView.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 23/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit.UIImageView

public class RoundImageView: RatioImageView {
    
    public init() {
        super.init(ratio: .oneToOne, cornerRadius: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        self.layer.cornerRadius = min(self.frame.height, self.frame.width)/2
    }
}
