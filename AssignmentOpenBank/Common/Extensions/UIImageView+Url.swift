//
//  UIImageView+Url.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 06/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit.UIImageView

extension UIImageView {
    
    public enum Animation {
        case none
        case fade
    }
    
    func getImageFrom(url: String, placeholderImage: UIImage? = nil, animation: Animation = .fade, success: ((Bool) -> Void)? = nil) {
        
        if let image = UIImage.getCacheImageFrom(url: url) {
            self.image = image
        } else if let placeholderImage = placeholderImage {
            self.image = placeholderImage
        }
        
        UIImage.getImageFrom(url: url, handler: { (image, _) in
            if animation == .fade {
                UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.image = image
                }, completion: { (_) in
                    if let success = success {
                        success(image != nil)
                    }
                })
            } else {
                self.image = image
                if let success = success {
                    success(image != nil)
                }
            }
        })
    }
    
}
