//
//  PageControl.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 04/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit.UIPageControl

public class PageControl: UIPageControl {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.currentPageIndicatorTintColor = .appMidGrey
        self.pageIndicatorTintColor = .appMidGrey
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    public func updateDots() {
        for (index, view) in self.subviews.enumerated() {
            UIView.animate(withDuration: 0.2, animations: {
                view.backgroundColor = self.currentPage == index ? .appBlue : .appMidGrey
            }, completion: nil)
        }
    }
    
}
