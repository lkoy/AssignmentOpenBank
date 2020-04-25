//
//  DialogController.swift
//  AssignmentOpenBank
//
//  Created by Iglesias, Gustavo on 15/04/2020.
//  Copyright © 2020 pips. All rights reserved.
//

import UIKit

public protocol DialogTracker: class {
    func opened()
    func tappedPrimary()
    func tappedSecondary()
    func tappedClose()
}

public extension DialogTracker {
    func opened() {}
    func tappedPrimary() {}
    func tappedSecondary() {}
    func tappedClose() {}
}

public final class DialogAction: NSObject {
    
    public enum Style {
        case primary
        case secondary
    }
    
    public var title: String!
    public var handler: ((DialogAction) -> Void)?
    public var style: Style = .primary
    public var itemSelected: Int?
    
    public convenience init(title: String, style: Style, handler: ((DialogAction) -> Void)? = nil, itemSelected: Int? = nil) {
        self.init()
        self.title = title
        self.style = style
        self.handler = handler
        self.itemSelected = itemSelected
    }
    
}

public final class DialogController: UIViewController {
    
    public enum Style {
        case alert
    }
    
    private var dialogController: UIViewController!
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(title: String?,
                            message: String?,
                            style: Style = .alert,
                            isDismissable: Bool = true,
                            isDismissableWhenTappingOut: Bool = false,
                            isLoading: Bool = false,
                            tracker: DialogTracker? = nil,
                            listItems: [String]? = nil) {
        
        self.init()
        switch style {
        case .alert:
            let alertDialog = AlertDialogController(title: title, message: message, tracker: tracker)
            modalTransitionStyle = .crossDissolve
            alertDialog.isDismissable = isDismissable
            alertDialog.isDismisableWithTappingOut = isDismissableWhenTappingOut
            dialogController = alertDialog
        }
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        addChild(dialogController)
        dialogController.didMove(toParent: self)
        view.addSubview(dialogController.view)
    }
    
    // MARK: - Public
    
    @objc public func addAction(_ action: DialogAction) {
        
        if dialogController.responds(to: #selector(addAction(_:))) {
            dialogController.perform(#selector(addAction(_:)), with: action)
        }
    }
}
