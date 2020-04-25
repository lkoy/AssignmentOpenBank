//
//  SendMoneyViewController.swift
//  AssignmentOpenBank
//
//  Created by pips on 27/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

final class SendMoneyViewController: BaseViewController {
    
    override var prefersNavigationBarHidden: Bool { return true }

    var presenter: SendMoneyPresenterProtocol!
    
    private var viewModel: SendMoney.ViewModel?
    
    // MARK: - Component Declaration
    private var topBar: TopBarView!

    private enum ViewTraits {
        static let marginsTopBar = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 0)
        static let userInfoViewMargins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        static let marginsIbanLabel = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
        static let marginsTransactionView = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        static let marginsQuatityView = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        static let marginsQuatityField = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 5)
        static let marginsButton = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
        static let imageSize: CGFloat = 50
        static let cornerRadius: CGFloat = 10
        static let spacing: CGFloat = 16.0
        static let buttonHeight: CGFloat = 50.0
    }
    
    private let userInfoView = UIView()
    private var ibanField: UITextField!
    
    private let transactionDataView = UIView()
    private let quantityView = UIView()
    private var quantityField: UITextField!
    private var currencyLabel: Label!
    private var messageField: UITextField!
    
    private var confirmButton: Button!
    private var bottomConstraint: NSLayoutConstraint!
    
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
        
        self.presenter.prepareView()
    }
    
    // MARK: - Setup

    override func setupComponents() {

        view.backgroundColor = .white
        
        topBar = TopBarView(type: .back)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.delegate = self
        view.addSubview(topBar)
        
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.backgroundColor = .appLigthGrey
        userInfoView.layer.cornerRadius = ViewTraits.cornerRadius
        view.addSubview(userInfoView)
        
        ibanField = UITextField()
        ibanField.textAlignment = .center
        ibanField.tintColor = .black
        ibanField.keyboardType = .default
        ibanField.placeholder = "ESXX XXXX XXXX XXXX XXXX XXXX"
        ibanField.text = "ES2300490001000000000011"
        ibanField.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.addSubview(ibanField)
        
        transactionDataView.translatesAutoresizingMaskIntoConstraints = false
        transactionDataView.backgroundColor = .appLigthGrey
        transactionDataView.layer.cornerRadius = ViewTraits.cornerRadius
        view.addSubview(transactionDataView)
        
        quantityView.translatesAutoresizingMaskIntoConstraints = false
        quantityView.backgroundColor = .clear
        transactionDataView.addSubview(quantityView)
        
        quantityField = UITextField()
        quantityField.textAlignment = .right
        quantityField.tintColor = .black
        quantityField.keyboardType = .numberPad
        quantityField.placeholder = "10"
        quantityField.font = .hugeBody2
        quantityField.translatesAutoresizingMaskIntoConstraints = false
        quantityView.addSubview(quantityField)
        
        currencyLabel = Label(style: .subtitle1, text: "€")
        currencyLabel.setContentHuggingPriority(.required, for: .horizontal)
        currencyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityView.addSubview(currencyLabel)
        
        messageField = UITextField()
        messageField.textAlignment = .center
        messageField.tintColor = .black
        messageField.keyboardType = .default
        messageField.placeholder = "Escribe un mensaje..."
        messageField.translatesAutoresizingMaskIntoConstraints = false
        transactionDataView.addSubview(messageField)
        
        confirmButton = Button(style: .primary)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        confirmButton.title = "ENVIAR"
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
    }

    override func setupConstraints() {

        bottomConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ViewTraits.marginsButton.bottom)
        
        NSLayoutConstraint.activate([
            
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewTraits.marginsTopBar.top),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            userInfoView.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: ViewTraits.userInfoViewMargins.top),
            userInfoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userInfoView.widthAnchor.constraint(equalTo: transactionDataView.widthAnchor),
            userInfoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ibanField.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: ViewTraits.marginsIbanLabel.top),
            ibanField.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor, constant: ViewTraits.marginsIbanLabel.left),
            ibanField.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor, constant: -ViewTraits.marginsIbanLabel.right),
            ibanField.bottomAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: -ViewTraits.marginsIbanLabel.bottom),
            
            transactionDataView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: ViewTraits.marginsTransactionView.top),
            transactionDataView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewTraits.marginsTransactionView.left),
            transactionDataView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewTraits.marginsTransactionView.right),
            
            quantityView.topAnchor.constraint(equalTo: transactionDataView.topAnchor, constant: ViewTraits.marginsQuatityView.top),
            quantityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quantityView.widthAnchor.constraint(lessThanOrEqualTo: transactionDataView.widthAnchor),
            quantityView.bottomAnchor.constraint(equalTo: messageField.topAnchor, constant: -ViewTraits.marginsQuatityView.bottom),
            
            quantityField.topAnchor.constraint(equalTo: quantityView.topAnchor),
            quantityField.trailingAnchor.constraint(equalTo: currencyLabel.leadingAnchor, constant: -ViewTraits.marginsQuatityField.right),
            quantityField.leadingAnchor.constraint(equalTo: quantityView.leadingAnchor, constant: ViewTraits.marginsQuatityView.left),
            quantityField.bottomAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: -ViewTraits.marginsQuatityView.bottom),
            
            currencyLabel.topAnchor.constraint(equalTo: quantityView.topAnchor, constant: ViewTraits.marginsQuatityView.top),
            currencyLabel.trailingAnchor.constraint(equalTo: quantityView.trailingAnchor, constant: -ViewTraits.marginsQuatityView.right),
            currencyLabel.bottomAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: -ViewTraits.marginsQuatityView.bottom),
            
            messageField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageField.leadingAnchor.constraint(equalTo: transactionDataView.leadingAnchor, constant: ViewTraits.marginsTransactionView.left),
            messageField.trailingAnchor.constraint(equalTo: transactionDataView.trailingAnchor, constant: -ViewTraits.marginsTransactionView.right),
            messageField.bottomAnchor.constraint(equalTo: transactionDataView.bottomAnchor, constant: -ViewTraits.marginsTransactionView.bottom),
            
            confirmButton.heightAnchor.constraint(equalToConstant: ViewTraits.buttonHeight),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewTraits.marginsButton.left),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewTraits.marginsButton.right),
            bottomConstraint
        ])
    }
    
    override func setupAccessibilityIdentifiers() {
        
    }

    // MARK: - Actions
    
    @objc private func confirmTapped() {

        self.presenter.sendMoney(iban: self.ibanField.text, amount: self.quantityField.text, concept: self.messageField.text)
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
            animateButton(duration: duration, offset: -ViewTraits.marginsButton.bottom)
        }
    }
    
    private func animateButton(duration: Double, offset: CGFloat) {
        bottomConstraint.constant = offset
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutSubviews()
        }, completion: nil)
    }

    private func update() {
        
        if let data = viewModel {
//            self.userNameLabel.text = data.name
//            self.userPhoneLabel.text = data.phone
//            self.userImageView.getImageFrom(url: data.imageUrl, placeholderImage: UIImage(named: "default_avatar"))
        }
    }
}

// MARK: - SendMoneyViewControllerProtocol
extension SendMoneyViewController: SendMoneyViewControllerProtocol {
 
    func show(_ viewModel: SendMoney.ViewModel) {
        
        self.viewModel = viewModel
        self.update()
    }
    
    func showLoadingState() {
        confirmButton.isLoading = true
    }
    
    func hideLoadingState() {
        confirmButton.isLoading = false
    }
}

// MARK: - TopBar Delegate
extension SendMoneyViewController: TopBarViewDelegate {
    
    func topBarView(_ topBarView: TopBarView, didPressItem item: Button) {
        
        presenter.close()
    }
}
