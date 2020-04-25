//
//  TopBarWebView.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 18/02/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit

public protocol TopBarWebViewDelegate: NSObjectProtocol {
    func topBarWebView(_ topBarWebView: TopBarWebView, didPressItem item: Button)
}

public final class TopBarWebView: UIView {
    
    weak var delegate: TopBarWebViewDelegate?
    
    public enum NavigationType {
        case close
        case back
        
        public var image: String {
            switch self {
            case .close: return "close_icon"
            case .back: return "back_icon"
            }
        }
    }
    
    private enum ViewTraits {
        static let containerMargins = UIEdgeInsets(top: 15, left: 15, bottom: 5, right: 15)
        static let buttonMargins = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 15)
        static let buttonSize: CGFloat = 40
    }
    
    private let contentView = UIView()
    
    private let button: Button = {
        let btn = Button(style: .image)
        return btn
    }()
    
    private var navigationType: NavigationType = .close {
        didSet {
            button.imageName = navigationType.image
        }
    }
    
    private var buttonBottomConstraint: NSLayoutConstraint!
    
    public convenience init(type: NavigationType = .close) {
        self.init(frame: CGRect.zero, type: type)
    }
    
    private init(frame: CGRect, type: NavigationType = .close) {
        super.init(frame: frame)
        
        backgroundColor = .appWhite
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .appWhite
        addSubview(contentView)
        
        navigationType = type
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageName = navigationType.image
        button.addTarget(self, action: #selector(didTouchUpInsideButton(sender:)), for: .touchUpInside)
        contentView.addSubview(button)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ViewTraits.containerMargins.left),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -ViewTraits.containerMargins.right),
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: ViewTraits.containerMargins.top),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -ViewTraits.containerMargins.bottom),
            
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -ViewTraits.buttonMargins.left),
            button.widthAnchor.constraint(equalToConstant: ViewTraits.buttonSize),
            button.heightAnchor.constraint(equalToConstant: ViewTraits.buttonSize),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTraits.buttonMargins.bottom)
            ])
    }
    
    // MARK: - Actions
    
    @objc func didTouchUpInsideButton(sender: Any?) {
        
        delegate?.topBarWebView(self, didPressItem: button)
    }
}
