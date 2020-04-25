//
//  RegistrationCompleteViewController.swift
//  AssignmentOpenBank
//
//  Created by pips on 16/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit
import Lottie

final class RegistrationCompleteViewController: BaseViewController {

    override var prefersNavigationBarHidden: Bool { return true }
    
    var presenter: RegistrationCompletePresenterProtocol!

    // MARK: - Component Declaration
    private var continueButton: Button!
    private var animationView = AnimationView(name: "complete_screen")

    private enum ViewTraits {
        static let margins = UIEdgeInsets(top: 0, left: 25, bottom: 25, right: 25)
        static let buttonHeight: CGFloat = 50.0
        static let completeSize: CGFloat = 300.0
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

    // MARK: - Setup

    override func setupComponents() {

        view.backgroundColor = .white
        
        continueButton = Button(style: .primary)
        continueButton.title = "EMPEZEMOS"
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundColor = .appRed
        animationView.isUserInteractionEnabled = false
        view.addSubview(animationView)
        animationView.play()
    }

    override func setupConstraints() {

        NSLayoutConstraint.activate([
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.heightAnchor.constraint(equalToConstant: ViewTraits.completeSize),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: ViewTraits.completeSize),
            
            continueButton.heightAnchor.constraint(equalToConstant: ViewTraits.buttonHeight),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewTraits.margins.left),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewTraits.margins.right),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ViewTraits.margins.bottom)])
    }
    
    override func setupAccessibilityIdentifiers() {
        
    }

    // MARK: - Actions

    @objc private func continueTapped() {
        
        self.presenter.continuePresed()
    }

    // MARK: Private Methods

}

// MARK: - RegistrationCompleteViewControllerProtocol
extension RegistrationCompleteViewController: RegistrationCompleteViewControllerProtocol {
 
}
