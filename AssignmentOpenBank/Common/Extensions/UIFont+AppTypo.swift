//
//  UIFont+AppTypo.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 11/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit.UIFont

extension UIFont {
    
    // MARK: - Heading
    
    open class var heading4: UIFont { return UIFont.boldAppFont(ofSize: Label.Style.heading4.size) }
    open class var heading5: UIFont { return UIFont.boldAppFont(ofSize: Label.Style.heading5.size) }
    open class var heading6: UIFont { return UIFont.boldAppFont(ofSize: Label.Style.heading6.size) }

    // MARK: - Title
    
    open class var title1: UIFont { return UIFont.boldAppFont(ofSize: Label.Style.title1.size) }
    open class var title2: UIFont { return UIFont.boldAppFont(ofSize: Label.Style.title2.size)}
    open class var title3: UIFont { return UIFont.boldAppFont(ofSize: Label.Style.title3.size) }
    
    // MARK: - Subtitle

    open class var subtitle1: UIFont { return UIFont.appFont(ofSize: Label.Style.subtitle1.size) }
    open class var subtitle2: UIFont { return UIFont.appFont(ofSize: Label.Style.subtitle2.size) }

    // MARK: - Body
    open class var hugeBody1: UIFont { return UIFont.appFont(ofSize: Label.Style.hugeBody1.size) }
    open class var hugeBody2: UIFont { return UIFont.appFont(ofSize: Label.Style.hugeBody2.size) }
    open class var body1: UIFont { return UIFont.appFont(ofSize: Label.Style.body1.size) }
    open class var body1Bold: UIFont { return UIFont.boldAppFont(ofSize: Label.Style.body1Bold.size) }
    open class var body2: UIFont { return UIFont.appFont(ofSize: Label.Style.body2.size) }
    
    // MARK: - Other

    open class var button: UIFont { return UIFont.boldAppFont(ofSize: Label.Style.button.size) }
    open class var caption: UIFont { return UIFont.appFont(ofSize: Label.Style.caption.size) }
    open class var overline: UIFont { return UIFont.boldAppFont(ofSize: Label.Style.overline.size) }
    open class var link: UIFont { return UIFont.appFont(ofSize: Label.Style.link.size) }

}
