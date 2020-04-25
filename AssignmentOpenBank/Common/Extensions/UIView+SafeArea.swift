//
//  UIView+SafeArea.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 11/01/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit.UIView

extension UIView {
    
    public var leadingAnchorSafeArea: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        } else {
            return leadingAnchor
        }
    }
    public var trailingAnchorSafeArea: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }
    public var topAnchorSafeArea: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            if let viewController = self.next as? UIViewController {
                return viewController.topLayoutGuide.bottomAnchor
            } else {
                return bottomAnchor
            }
        }
    }
    public var bottomAnchorSafeArea: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            if let viewController = self.next as? UIViewController {
                return viewController.bottomLayoutGuide.topAnchor
            } else {
                return bottomAnchor
            }
        }
    }
    public var safeAreaInsetsMod: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return safeAreaInsets
        } else {
            return UIEdgeInsets.zero
        }
    }

}

extension UIScrollView {
    
    public var universalAdjustedContentInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        }
        return contentInset
    }
    
}
