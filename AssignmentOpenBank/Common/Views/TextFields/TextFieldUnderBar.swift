//
//  TextFieldUnderBar.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 11/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

private protocol ViewTraitsProtocol {
    
    var textFieldMargins: UIEdgeInsets {get}
    var errorMessageMargins: UIEdgeInsets {get}
    var textFieldSize: CGSize {get}
    var bottomLineSize: CGSize {get}
    var bottomLineCompleteHeight: CGFloat {get}
    var viewHeight: CGFloat {get}
    var bottomLineCompleteColor: UIColor {get}
    var textFieldFont: UIFont {get}
    var textfieldAccesibitlyId: String {get}
    var bottomConstantConstraint: CGFloat {get}
}

public final class TextFieldUnderBar: UIView {
    
    public enum PumpType {
        case regular
        case big
    }
    
    public enum Style {
        case incomplete
        case complete
        case error(message: String)
    }
    
    public private(set) var textfield: UITextField!
    private var bottomLine: UIView!
    private var errorMessage: Label!
    
    override public var tag: Int {
        didSet {
            textfield.tag = tag
        }
    }
    
    public weak var delegate: UITextFieldDelegate? {
        didSet {
            textfield.delegate = delegate
        }
    }
    
    private var viewDetails: ViewTraitsProtocol!
    
    public var style: Style = .incomplete {
        didSet {
            updateViewWith(style: style)
        }
    }
    
    public enum AccessibilityIds {
        public static let textFieldRegular: String = "textField-pump-regular"
        public static let textFieldBig: String = "textField-pump-big"
        public static let textFieldError: String = "textField-pump-error"
    }
    
    private enum ViewTraits {
        
         struct Regular: ViewTraitsProtocol {
            var textFieldMargins: UIEdgeInsets { return UIEdgeInsets(top: 5, left: 16, bottom: -5, right: -16) }
            var errorMessageMargins: UIEdgeInsets { return UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0) }
            var textFieldSize: CGSize { return CGSize(width: 190, height: 28) }
            var bottomLineSize: CGSize { return  CGSize(width: 190, height: 2) }
            var bottomLineCompleteHeight: CGFloat { return 1.0 }
            var viewHeight: CGFloat { return 50.0 }
            var bottomLineCompleteColor: UIColor { return .appRed }
            var textFieldFont: UIFont { return  .heading5 }
            var textfieldAccesibitlyId: String { return AccessibilityIds.textFieldRegular}
            var bottomConstantConstraint: CGFloat { return -10 }
        }
        
         struct Big: ViewTraitsProtocol {
            var textFieldMargins: UIEdgeInsets { return UIEdgeInsets(top: 8, left: 16, bottom: -8, right: -16) }
            var errorMessageMargins: UIEdgeInsets { return UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0) }
            var textFieldSize: CGSize { return CGSize(width: 220, height: 58) }
            var bottomLineSize: CGSize { return  CGSize(width: 220, height: 2) }
            var bottomLineCompleteHeight: CGFloat { return 1.0 }
            var viewHeight: CGFloat { return 97.0 }
            var bottomLineCompleteColor: UIColor { return .appRed }
            var textFieldFont: UIFont { return  .hugeBody2 }
            var textfieldAccesibitlyId: String { return AccessibilityIds.textFieldBig}
            var bottomConstantConstraint: CGFloat { return -23 }
        }
    }

    private var bottonLineHeigthLayoutConstraint: NSLayoutConstraint!

    public required init(type: PumpType) {
        
        super.init(frame: CGRect.zero)
        self.viewDetails = type == .big ? ViewTraits.Big() : ViewTraits.Regular()
        setUpViewComponents()
    }
    
    private func setUpViewComponents() {
    
        backgroundColor = .white
    
        textfield = UITextField()
        textfield.font = viewDetails.textFieldFont
        textfield.textAlignment = .center
        textfield.tintColor = .darkGray
        textfield.keyboardType = .alphabet
        textfield.accessibilityIdentifier = viewDetails.textfieldAccesibitlyId
        textfield.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textfield)
    
        bottomLine = UIView()
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
    
        errorMessage = Label(style: .caption)
        errorMessage.labelColor = .appYellow
        errorMessage.textAlignment = .center
        errorMessage.accessibilityIdentifier = AccessibilityIds.textFieldError
        errorMessage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(errorMessage)
    
        setupConstraints()
        updateViewWith(style: self.style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        bottonLineHeigthLayoutConstraint = bottomLine.heightAnchor.constraint(equalToConstant: viewDetails.bottomLineCompleteHeight)

        let bottomLineBottomConstraint = bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: viewDetails.bottomConstantConstraint)
        bottomLineBottomConstraint.priority = .defaultHigh
        
        let errorMessageConstraint = errorMessage.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: viewDetails.errorMessageMargins.top)
        errorMessageConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            
            textfield.topAnchor.constraint(equalTo: self.topAnchor, constant: viewDetails.textFieldMargins.top),
            textfield.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textfield.widthAnchor.constraint(equalToConstant: viewDetails.textFieldSize.width),

            bottomLine.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: viewDetails.textFieldMargins.top),
            bottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottonLineHeigthLayoutConstraint,
            bottomLine.widthAnchor.constraint(equalTo: textfield.widthAnchor),
            bottomLineBottomConstraint,
            
            errorMessageConstraint,
            errorMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: viewDetails.errorMessageMargins.bottom),
            errorMessage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            errorMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
   private func updateViewWith(style: Style) {
        
        switch style {
        case .complete:
            bottonLineHeigthLayoutConstraint.constant = viewDetails.bottomLineCompleteHeight
            bottomLine.backgroundColor = viewDetails.bottomLineCompleteColor
            errorMessage.isHidden = true

        case .incomplete:
            bottonLineHeigthLayoutConstraint.constant = viewDetails.bottomLineSize.height
            bottomLine.backgroundColor = .appLigthGrey
            errorMessage.isHidden = true

        case .error(let message):
            bottonLineHeigthLayoutConstraint.constant = viewDetails.bottomLineSize.height
            bottomLine.backgroundColor = .appYellow
            errorMessage.text = message
            errorMessage.isHidden = false
        }
        
        layoutIfNeeded()
    }
    
    public func setPlaceholderWith(text placeholder: String) {
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.appLigthGrey])
    }
    
    public func setValue(value: String) {
        textfield.text = value
    }
}
