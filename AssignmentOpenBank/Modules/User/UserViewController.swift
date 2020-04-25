//
//  UserViewController.swift
//  AssignmentOpenBank
//
//  Created by pips on 25/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit

final class UserViewController: BaseViewController {
    
    override var prefersNavigationBarHidden: Bool { return true }

    var presenter: UserPresenterProtocol!

    // MARK: - Component Declaration

    private var imageIcon: UIImageView!
    private var titleLabel: Label!
    private var nameField: TextFieldUnderBar!
    private var continueButton: Button!
    
    private var bottomConstraint: NSLayoutConstraint!

    private enum ViewTraits {
        static let imageIconMargins = UIEdgeInsets(top: 70, left: 0, bottom: 30, right: 0)
        static let imageWidth: CGFloat = 100.0
        static let imageHeight: CGFloat = 100.0
        static let margins = UIEdgeInsets(top: 0, left: 25, bottom: 25, right: 25)
        static let spacing: CGFloat = 16.0
        static let buttonHeight: CGFloat = 50.0
    }
    
    public enum AccessibilityIds {
        
    }

    // MARK: - ViewLife Cycle
    /*
     Order:
     - viewDidLoad
     - viewWillAppear
     - viewDidAppear
     - viewWillDisapear
     - viewDidDisappear
     - viewWillLayoutSubviews
     - viewDidLayoutSubviews
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        presenter.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showKeyboard()
    }
    
    // MARK: - Setup

    override func setupComponents() {

        view.backgroundColor = .white
        
        imageIcon = UIImageView(image: UIImage(named: "santander_logo_small"))
        imageIcon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageIcon)
        
        titleLabel = Label(style: .title3, text: "¿COMO TE LLAMAS?")
        titleLabel.textColor = .appRed
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        nameField = TextFieldUnderBar(type: TextFieldUnderBar.PumpType.regular)
        nameField.setPlaceholderWith(text: "John Doe")
        nameField.style = .complete
        nameField.textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
        
        continueButton = Button(style: .primary)
        continueButton.title = "EMPEZEMOS"
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
    }

    override func setupConstraints() {

        bottomConstraint = continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ViewTraits.margins.bottom)
        NSLayoutConstraint.activate([
            imageIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewTraits.imageIconMargins.top),
            imageIcon.widthAnchor.constraint(equalToConstant: ViewTraits.imageWidth),
            imageIcon.heightAnchor.constraint(equalToConstant: ViewTraits.imageHeight),
            imageIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageIcon.bottomAnchor, constant: ViewTraits.imageIconMargins.bottom),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            continueButton.heightAnchor.constraint(equalToConstant: ViewTraits.buttonHeight),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewTraits.margins.left),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewTraits.margins.right),
            bottomConstraint])
    }
    
    override func setupAccessibilityIdentifiers() {
        
    }

    // MARK: - Actions
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        presenter.nameEntered(textField.text)
    }
    
    @objc private func continueTapped() {
        
        self.presenter.createUser(name: nameField.textfield.text)
    }

    // MARK: Private Methods

    @objc private func keyBoardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            animateButton(duration: duration, offset: -(ViewTraits.spacing + keyboardSize.height))
        }
    }
    
    @objc private func keyBoardWillHide(notification: NSNotification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            animateButton(duration: duration, offset: -ViewTraits.margins.bottom)
        }
    }
    
    private func animateButton(duration: Double, offset: CGFloat) {
        bottomConstraint.constant = offset
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutSubviews()
        }, completion: nil)
    }
}

// MARK: - UserViewControllerProtocol
extension UserViewController: UserViewControllerProtocol {
 
    func showKeyboard() {
        
        nameField.textfield.becomeFirstResponder()
    }
    
    func show(_ viewModel: User.ViewModel) {
        
        nameField.setValue(value: viewModel.nameFieldText ?? "")
    }
    
    func showLoadingState() {
        
        continueButton.isLoading = true
    }
    
    func hideLoadingState() {
        
        continueButton.isLoading = false
    }
}
