//
//  UIViewController+NavigarionBar.swift
//  AssignmentMoneyou
//
//  Created by Iglesias, Gustavo on 23/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
    
    @objc open var prefersNavigationBarHidden: Bool {
        return false
    }
    
    @objc open var prefersNavigationBackButtonHidden: Bool {
        return false
    }
}
