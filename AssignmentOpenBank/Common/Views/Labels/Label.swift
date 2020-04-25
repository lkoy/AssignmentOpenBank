//
//  Label.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 11/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

public protocol LabelDelegate: class {
    func didTapURL(label: Label, url: URL)
}

public class Label: UILabel {
    
    public weak var delegate: LabelDelegate?
    
    public enum Style: CaseIterable {
        case hugeBody1
        case hugeBody2
        case heading4
        case heading5
        case heading6
        case title1
        case title2
        case title3
        case subtitle1
        case subtitle2
        case body1
        case body1Bold
        case body2
        case button
        case caption
        case overline
        case link
        
        public var name: String { return String(describing: self) }
        public var description: String { return String(reflecting: self) }
        
        public var numberOfLines: Int {
            switch self {
            default: return 0
            }
        }
        
        public var letterSpacing: CGFloat {
            switch self {
            case .hugeBody1,
                 .hugeBody2,
                 .title1,
                 .title2,
                 .heading5:
                return 0
            case .heading4: return 0.25
            case .heading6: return 0.25
            case .subtitle1,
                 .title3: return 0.15
            case .subtitle2: return 0.11
            case .body1, .body1Bold: return 0.5
            case .body2: return 0.25
            case .button: return 0.0 //0.25
            case .caption: return 0.4
            case .overline: return 2
            case .link: return 0.25
            }
        }
        
        public var lineHeightMultiple: CGFloat {
            var newLineHeight: CGFloat = 1.0
            switch self {
            case .hugeBody1: newLineHeight = lineHeight
            case .hugeBody2: newLineHeight = lineHeight
            case .heading4: newLineHeight = lineHeight
            case .heading5: newLineHeight = lineHeight
            case .heading6: newLineHeight = lineHeight
            case .title1: newLineHeight = lineHeight
            case .title2: newLineHeight = lineHeight
            case .subtitle1,
                 .title3: newLineHeight = lineHeight
            case .subtitle2: newLineHeight = lineHeight
            case .body1, .body1Bold: newLineHeight = (lineHeight - 4) //Yes, magic number
            case .body2: newLineHeight = (lineHeight - 3.5) //Yes, magic number
            case .button: newLineHeight = lineHeight
            case .caption: newLineHeight = lineHeight
            case .overline: newLineHeight = lineHeight
            case .link: return 1.0 //lineHeight / 14.0
            }
            return newLineHeight / size
        }
        
        public var lineHeight: CGFloat {
            var lineHeight: CGFloat = 0.0
            switch self {
            case .hugeBody1: lineHeight = 98.0
            case .hugeBody2: lineHeight = 48.0
            case .heading4: lineHeight = 40.0
            case .heading5: lineHeight = 32.0
            case .heading6: lineHeight = 24.0
            case .title1: lineHeight = 35.0
            case .title2: lineHeight = 22.0
            case .subtitle1: lineHeight = 18.0
            case .title3: lineHeight = 20.0
            case .subtitle2: lineHeight = 20.0
            case .body1, .body1Bold: lineHeight = 24.0
            case .body2: lineHeight = 20.0
            case .button: lineHeight = 20.0 // 24.0
            case .caption: lineHeight = 13.0
            case .overline: lineHeight = 16.0
            case .link: break//24.0
            }
            return lineHeight
        }
        
        public var casing: Casing {
            switch self {
            case .overline: return .uppercase
            default: return .sentence
            }
        }
        
        public var font: UIFont {
            switch self {
            case .hugeBody1: return UIFont.hugeBody1
            case .hugeBody2: return UIFont.hugeBody2
            case .heading4: return UIFont.heading4
            case .heading5: return UIFont.heading5
            case .heading6: return UIFont.heading6
            case .title1: return UIFont.title1
            case .title2: return UIFont.title2
            case .title3: return UIFont.title3
            case .subtitle1: return UIFont.subtitle1
            case .subtitle2: return UIFont.subtitle2
            case .body1: return UIFont.body1
            case .body1Bold: return UIFont.body1Bold
            case .body2: return UIFont.body2
            case .button: return UIFont.button
            case .caption: return UIFont.caption
            case .overline: return UIFont.overline
            case .link: return UIFont.link
            }
        }
        
        public var underlined: Bool {
            switch self {
            case .link: return true
            default: return false
            }
        }
        
//        var isHTML: Bool {
//            switch self {
//            case .body1: return true
//            case .body2: return true
//            default: return false
//            }
//        }
        
        public var color: UIColor {
            switch self {
            case .hugeBody1, .hugeBody2: return UIColor.appDarkGrey
            case .heading4, .heading5, .heading6: return UIColor.appOrange
            case .title1,
                 .title2,
                 .title3: return UIColor.appBlack
            case .subtitle1: return UIColor.appDarkGrey
            case .subtitle2: return UIColor.appMidGrey
            case .body1: return UIColor.appDarkGrey
            case .body1Bold: return UIColor.appDarkGrey
            case .body2: return UIColor.appDarkGrey
            case .caption: return UIColor.appDarkGrey
            case .overline: return UIColor.appDarkGrey
            default: return UIColor.appDarkGrey
            }
        }
        
        public var size: CGFloat {
            switch self {
            case .hugeBody1: return 98
            case .hugeBody2: return 48
            case .heading4: return 35
            case .heading5: return 24
            case .heading6: return 18
            case .title1: return 30
            case .title2: return 20
            case .title3: return 17
            case .subtitle1: return 16
            case .subtitle2: return 16
            case .body1, .body1Bold: return 16
            case .body2: return 14
            case .button: return 16
            case .caption: return 12
            case .overline: return 10
            case .link: return 14
            }
        }
    }

    public enum Casing {
        case sentence
        case uppercase
        
        func process(text: String) -> String {
            var string = text
            switch self {
            case .uppercase: string = string.uppercased()
            case .sentence: break
            }
            
            return string
        }
    }
    
    public var isHTML: Bool = false
    public var linksColor: UIColor?
    public var automaticHandleLinks: Bool = true
    private var lineHeight: CGFloat
    private var letterSpacing: CGFloat
    
    private let shimmerLoader = LoaderView()
    
    public var isLoading: Bool = false {
        didSet {
            if isLoading {
                shimmerLoader.isHidden = false
                shimmerLoader.startShimmering()
            } else {
                shimmerLoader.isHidden = true
                shimmerLoader.stopShimmering()
            }
        }
    }
    
    public var style: Style = .body1 {
        didSet {
            if oldValue != style {
                updateStyle()
                reloadStyle(with: text)
            }
        }
    }
    
    public var casing: Casing = .sentence {
        didSet {
            if oldValue != casing {
                reloadStyle(with: text)
            }
        }
    }
    
    public var underlined: Bool = false {
        didSet {
            if oldValue != underlined {
                reloadStyle(with: text)
            }
        }
    }
    
    public var labelColor: UIColor? {
        didSet {
            if oldValue != labelColor {
                updateStyle()
                reloadStyle(with: text)
            }
        }
    }
    
    private final var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = self.style.lineHeightMultiple /// 0.16
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        return style
    }
    
    private var attributes: [NSAttributedString.Key: Any] {
        var att: [NSAttributedString.Key: Any] = [:]
        att[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        att[NSAttributedString.Key.underlineStyle] = underlined ? NSUnderlineStyle.single.rawValue : 0
        att[NSAttributedString.Key.kern] = letterSpacing
        return att
    }
    
    override public var text: String? {
        set {
            if shouldUpdateText(old: text, new: newValue) {
                updateStyle()
                reloadStyle(with: newValue)
                }
            }
        get { return super.text }
    }
    
    override public var font: UIFont! {
        didSet {
            if oldValue != font {
                reloadStyle(with: text)
            }
        }
    }
    
    private var links: [(text: String, url: URL)] = []
    private var tapGesture: UITapGestureRecognizer?
    
    public convenience init(style: Style = .body2, text: String? = nil) {
        
        self.init(frame: CGRect.zero)
        
        self.style = style
        self.text = text
        self.numberOfLines = 0
        updateStyle()
        reloadStyle(with: text)
        setUpLoaderComponent()
        setUpLoaderConstraints()
        
    }
    
    private override init(frame: CGRect) {
        
        self.lineHeight = 1.3
        self.letterSpacing = 0.0
        self.underlined = false
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateStyle() {
        
        lineBreakMode = .byTruncatingTail
        textColor = labelColor ?? style.color
        letterSpacing = style.letterSpacing
        lineHeight = style.lineHeight
        casing = style.casing
        underlined = style.underlined
        //isHTML = style.isHTML
        font = style.font
    }
    
    private func shouldUpdateText(old: String?, new: String?) -> Bool {
        
        guard text != nil else {
            return true
        }
        
        if isHTML {
            let newnew =  casing.process(text: new ?? "")
            let attributedString = newnew.htmlAttributed(family: font.familyName, size: font.pointSize, isBold: font.isBold, color: textColor, letterSpacing: style.letterSpacing, lineHeight: style.lineHeight, isUnderlined: underlined)
            return old != attributedString?.string
        } else {
            return old != new
        }
    }
    
    private func reloadStyle(with textValue: String?) {
        
        guard let text = textValue else {
            return
        }
        
        let newText = casing.process(text: text)
        
        if isHTML {
            
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGesture(_:)))
            addGestureRecognizer(tapGesture!)
            
            self.isUserInteractionEnabled = true
            let attributedString = newText.htmlAttributed(family: font.familyName, size: font.pointSize, isBold: font.isBold, color: textColor, letterSpacing: style.letterSpacing, lineHeight: style.lineHeight, isUnderlined: underlined)
            self.attributedText = attributedString
            
            links.removeAll()
            if let attributedString = attributedString {
                let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                attributedString.enumerateAttributes(in: NSRange(0..<attributedString.length)) { (value, range, _) in
                    if value.keys.contains(NSAttributedString.Key.link) {
                        let start = text.index(text.startIndex, offsetBy: range.location)
                        let end = text.index(text.startIndex, offsetBy: range.location+range.length)
                        if let txt = self.text?[start..<end], let link = value[NSAttributedString.Key.link] as? URL {
                            links.append((text: String(txt), url: (link)))
                            if let linksColor = self.linksColor {
                                mutableAttributedString.removeAttribute(.link, range: range)
                                mutableAttributedString.addAttribute(.foregroundColor, value: linksColor, range: range)
                                mutableAttributedString.addAttribute(.underlineColor, value: linksColor, range: range)
                                
                                self.attributedText = mutableAttributedString
                            }
                        }
                    }
                }
            }
                
        } else {
            
            if let tapGesture = tapGesture {
                removeGestureRecognizer(tapGesture)
                self.tapGesture = nil
            }
            
            self.isUserInteractionEnabled = false
            let attributedString = NSAttributedString(string: newText, attributes: attributes)
            self.attributedText = attributedString
        }
    }
    
    private func setUpLoaderComponent() {
        
        shimmerLoader.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shimmerLoader)
    }
    
    private func setUpLoaderConstraints() {
        
        NSLayoutConstraint.activate([
            shimmerLoader.leadingAnchor.constraint(equalTo: leadingAnchor),
            shimmerLoader.trailingAnchor.constraint(equalTo: trailingAnchor),
            shimmerLoader.topAnchor.constraint(equalTo: topAnchor),
            shimmerLoader.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    // MARK: - Gesture
    
    @objc func didTapGesture(_ gesture: UITapGestureRecognizer) {
        
        guard let text = self.text, isHTML else {
            return
        }
        
        for link in links {
            let range = (text as NSString).range(of: link.text)
            if gesture.didTapAttributedTextInLabel(label: self, inRange: range) {
                delegate?.didTapURL(label: self, url: link.url)
                if automaticHandleLinks {
                    UIApplication.shared.open(link.url, options: [:], completionHandler: nil)
                }
                break
            }
        }
    }
}

private extension UIFont {
 
    var isBold: Bool {
        let dict = CTFontCopyTraits(self as CTFont) as Dictionary
        if let weightNumber = dict[kCTFontWeightTrait] as? NSNumber, weightNumber.doubleValue > 0 {
            return true
        } else {
            return false
        }
    }
}

public extension UIColor {
    
    var hexString: String {
        if let components = self.cgColor.components, components.count >= 3 {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return "FFFFFF"
    }
}

private extension String {
    
    func htmlAttributed(family: String?, size: CGFloat, isBold: Bool, color: UIColor, letterSpacing: CGFloat, lineHeight: CGFloat, isUnderlined: Bool) -> NSAttributedString? {
        
        do {
            var fontFamily = "-apple-system"
            if let family = family, family != ".SF UI Text" && family == ".SF UI Display" {
                fontFamily = family
            }
            
            let fontWeight = isBold ? "font-weight: bold !important; " : ""
            let textDecoration = isUnderlined ? "text-decoration: underline !important; " : ""
            
            let htmlCSSString = "<style>" +
                "body {" +
                    "font-size: \(size)px !important; " +
                    "\(fontWeight)" +
                    "color: #\(color.hexString) !important; " +
                    "font-family: '\(fontFamily)' !important; " +
                    "letter-spacing: \(letterSpacing)px !important; " +
                    "line-height: \(lineHeight)px !important; " +
                    "\(textDecoration)" +
                "}" +
                "</style>" +
                "<body>\(self)</body>"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

private extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
