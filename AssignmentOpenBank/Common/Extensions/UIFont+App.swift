//
//  UIFont+App.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 11/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit.UIFont

public extension UIFont {
    
    enum ShellFont: CaseIterable {
        case pipsBold
        case pipsRegular
        case pipsMedium
        case pipsLight
        
        var name: String {
            switch self {
            case .pipsBold:
                return "Pips-Bold"
            case .pipsRegular:
                return "Pips-Regular"
            case .pipsMedium:
                return "Pips-Medium"
            case .pipsLight:
                return "Pips-Light"
            }
        }
        
        public var fileName: String {
            switch self {
            case .pipsBold:
                return "Pips-Bold.ttf"
            case .pipsRegular:
                return "Pips-Regular.ttf"
            case .pipsMedium:
                return "Pips-Medium.ttf"
            case .pipsLight:
                return "Pips-Light.ttf"
            }
        }
        
        public init(name: String) {
            switch name {
            case UIFont.ShellFont.pipsBold.name:
               self = .pipsBold
            case UIFont.ShellFont.pipsMedium.name:
                self = .pipsMedium
            case UIFont.ShellFont.pipsLight.name:
                self = .pipsLight
            default:
                // UIFont.ShellFont.shellBook.name
                self = .pipsRegular
            }
        }
    }
    
}
    
extension UIFont {
    
    open class func appFont(ofSize fontSize: CGFloat) -> UIFont {
        if let futuraFont = UIFont(name: UIFont.ShellFont.pipsRegular.name, size: fontSize) {
            return scaled(font: futuraFont)
        } else {
            return scaled(font: UIFont.systemFont(ofSize: fontSize))
        }
    }
    
    open class func boldAppFont(ofSize fontSize: CGFloat) -> UIFont {
        if let futuraFont = UIFont(name: UIFont.ShellFont.pipsBold.name, size: fontSize) {
            return scaled(font: futuraFont)
        } else {
            return scaled(font: UIFont.boldSystemFont(ofSize: fontSize))
        }
    }
    
    open class func mediumAppFont(ofSize fontSize: CGFloat) -> UIFont {
        if let futuraFont = UIFont(name: UIFont.ShellFont.pipsMedium.name, size: fontSize) {
            return scaled(font: futuraFont)
        } else {
            return scaled(font: UIFont.boldSystemFont(ofSize: fontSize))
        }
    }
    
    open class func lightBoldAppFont(ofSize fontSize: CGFloat) -> UIFont {
        if let futuraFont = UIFont(name: UIFont.ShellFont.pipsLight.name, size: fontSize) {
            return scaled(font: futuraFont)
        } else {
            return scaled(font: UIFont.boldSystemFont(ofSize: fontSize))
        }
    }
    
    private class func scaled(font: UIFont) -> UIFont {
        
        let scaledFont = UIFontMetrics.default.scaledFont(for: font)
        return scaledFont
    }
    
}

public extension UIFont {
    
    /**
     Register the embeded fonts in framework into the main app.
     Should be initialize in the AppDelegate.
     */
    static func registerPipsDesingSystemFonts() {
        
        //print("Register Font in Bundle " + bundle.bundleURL.absoluteString)
        
        for font in UIFont.ShellFont.allCases {
            
            guard let pathForResourceString = Bundle.components.path(forResource: font.fileName, ofType: nil, inDirectory: "Fonts.bundle") else {
                print("Register Font Failed to register font \(font.name) - path for resource not found.")
                return
            }
            
            guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
                print("Register Font Failed to register font \(pathForResourceString) - font data could not be loaded.")
                return
            }
            
            guard let dataProvider = CGDataProvider(data: fontData) else {
                print("Register Font Failed to register font \(pathForResourceString) - data provider could not be loaded.")
                return
            }
            
            guard let font = CGFont(dataProvider) else {
                print("Register Font Failed to register font \(pathForResourceString) - font could not be loaded.")
                return
            }
            
            var errorRef: Unmanaged<CFError>?
            if CTFontManagerRegisterGraphicsFont(font, &errorRef) == false {
                print("Register Font Failed to register font \(String(describing: font.name)) - this font may have already been registered in the main bundle.")
            }
        }
    }
    
}

public extension UIFont {
    
    /**
     Print intalled fonts in the device
     */
    static func printFamilyNames() {
        for family: String in UIFont.familyNames {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
    }
    
}
