//
//  AlertDialogController.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 15/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit

public final class AlertDialogController: UIViewController {
    
    private struct ViewTraits {
        static let containerMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        static let labelsStackMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        static let buttonsStackMargins = UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16)
        static let minHeight: CGFloat = 50
    }
    
    private let charsForVerticalAlignment: Int = 12
    
    var message: String?
    private var buttonsAlignment: NSLayoutConstraint.Axis = .horizontal
    
    private let shadowView = UIView()
    private let contentView = UIView()
    private let labelsStackView = UIStackView()
    private var titleLabel: Label?
    private var messageLabel: Label?
    private let buttonsStackView = UIStackView()
    private var primaryAction: DialogAction?
    private let primaryButton = Button(style: .primary)
    private var secondaryAction: DialogAction?
    private let secondaryButton = Button(style: .secondary)
    private var tracker: DialogTracker?
    var isDismissable: Bool = true
    var isDismisableWithTappingOut: Bool = false
    
    public enum AccessibilityIds {
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String?, message: String?, tracker: DialogTracker? = nil) {
        
        self.init()
        
        self.title = title
        self.message = message
        self.tracker = tracker
    }
    
    public override func loadView() {
        
        return super.loadView()
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.64)
        
        if let primaryAction = primaryAction, let secondaryAction = secondaryAction {
            if primaryAction.title.count >= charsForVerticalAlignment || secondaryAction.title.count >= charsForVerticalAlignment {
                buttonsAlignment = .vertical
            }
        }
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = .appWhite
        shadowView.layer.applyShadow(.dp8)
        shadowView.layer.cornerRadius = 4
        view.addSubview(shadowView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .appWhite
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = shadowView.layer.cornerRadius
        shadowView.addSubview(contentView)
        
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.spacing = 0
        labelsStackView.axis = .vertical
        contentView.addSubview(labelsStackView)
        
        if title != nil {
            titleLabel = Label(style: .title3)
            titleLabel?.text = title
            titleLabel?.labelColor = .appBlack
            titleLabel?.numberOfLines = 1
            labelsStackView.addArrangedSubview(titleLabel!)
        }
        
        if message != nil {
            messageLabel = Label(style: .body1)
            messageLabel?.text = message
            messageLabel?.numberOfLines = 5
            labelsStackView.addArrangedSubview(messageLabel!)
            messageLabel?.textColor = .appDarkGrey
        }
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.spacing = 8
        buttonsStackView.axis = buttonsAlignment
        buttonsStackView.distribution = .fillEqually
        contentView.addSubview(buttonsStackView)
        
        if secondaryAction != nil {
            secondaryButton.title = secondaryAction?.title
            secondaryButton.addTarget(self, action: #selector(didPressSecondaryButton(_:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(secondaryButton)
        }
        
        if primaryAction != nil {
            primaryButton.title = primaryAction?.title
            primaryButton.addTarget(self, action: #selector(didPressPrimaryButton(_:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(primaryButton)
        }
        
        setupConstraints()
        setupAccessibilityIdentifiers()
        
        tracker?.opened()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        
        if isDismisableWithTappingOut, touches.first?.view == view {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewTraits.containerMargins.left),
            shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewTraits.containerMargins.right),
            shadowView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            shadowView.heightAnchor.constraint(greaterThanOrEqualToConstant: ViewTraits.minHeight)
            ])
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: 0),
            contentView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            
            labelsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.labelsStackMargins.left),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTraits.labelsStackMargins.right),
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTraits.labelsStackMargins.top),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.buttonsStackMargins.left),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTraits.buttonsStackMargins.right),
            buttonsStackView.topAnchor.constraint(greaterThanOrEqualTo: labelsStackView.bottomAnchor, constant: ViewTraits.buttonsStackMargins.top),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTraits.buttonsStackMargins.bottom)
            ])
    }
    
    private func setupAccessibilityIdentifiers() {
        
    }
    
    // MARK: - Public
    
    @objc func addAction(_ action: DialogAction) {
        
        switch action.style {
        case .primary:
            primaryAction = action
        case .secondary:
            secondaryAction = action
            break
        }
    }
    
    // MARK: - Actions
    
    @objc func didPressPrimaryButton(_ button: UIButton) {
        tracker?.tappedPrimary()
        performAction(primaryAction)
    }
    
    @objc func didPressSecondaryButton(_ button: UIButton) {
        tracker?.tappedSecondary()
        performAction(secondaryAction)
    }
    
    private func performAction(_ action: DialogAction?) {
        if let action = action, let handler = action.handler {
            performAction(action: handler(action))
        } else if isDismissable {
            dismiss()
        }
    }
    
    private func performAction(action: @escaping @autoclosure () -> Void ) {
        if isDismissable {
            dismiss {
                action()
            }
        } else {
            action()
        }
    }
    
    private func dismiss(completion: (() -> Void)? = nil) {
        super.dismiss(animated: true, completion: completion)
    }
}
