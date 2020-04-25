//
//  BaseViewController.swift
//  AssignmentMoneyou
//
//  Created by Iglesias, Gustavo on 22/09/2019.
//  Copyright © 2019 ttg. All rights reserved.
//

import UIKit.UIViewController

protocol ViewSetupProtocol {
    func setupComponents()
    func setupConstraints()
}

class BaseViewController: UIViewController, ViewSetupProtocol {

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        setupConstraints()
        setupAccessibilityIdentifiers()
    
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Hide/Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(self.prefersNavigationBarHidden, animated: animated)
        
        if transitionCoordinator?.initiallyInteractive ?? false {
            transitionCoordinator?.notifyWhenInteractionChanges({ (context) in
                if context.isCancelled {
                    self.viewWillFinallyAppear(animated)
                    
                }
            })
        } else {
            self.viewWillFinallyAppear(animated)
        }
    }

    func viewWillFinallyAppear(_ animated: Bool) {

    }
    
    func setupComponents() {
        fatalError("Missing implementation of \"setupComponents\"")
    }

    func setupConstraints() {
        fatalError("Missing implementation of \"setupConstraints\"")
    }
    
    func setupAccessibilityIdentifiers() {
        fatalError("Missing implementation of \"setupAccessibilityIdentifiers\"")
    }
    
    func sendFloatingActionButtonEvent() {
        
    }
}
