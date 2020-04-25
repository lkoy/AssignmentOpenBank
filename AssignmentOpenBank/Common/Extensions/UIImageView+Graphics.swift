//
//  UIImage+Graphics.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 23/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

extension UIImageView {
    func makeRounded() {

        self.layer.masksToBounds = false
        self.layer.cornerRadius = CGFloat(roundf(Float(self.frame.size.width/2.0)))
    }
}
