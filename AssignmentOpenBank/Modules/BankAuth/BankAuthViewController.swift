//
//  BankAuthViewController.swift
//  AssignmentOpenBank
//
//  Created by pips on 14/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit
import WebKit

final class BankAuthViewController: BaseViewController {
    
    override var prefersNavigationBarHidden: Bool { return true }

    var presenter: BankAuthPresenterProtocol!

    // MARK: - Component Declaration

    private enum ViewTraits {
        static let marginsTopBar = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 0)
        static let margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private var topBar: TopBarWebView!
    private var webView: WKWebView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presenter.prepareView()
    }

    // MARK: - Setup

    override func setupComponents() {

        view.backgroundColor = .appWhite
        
        topBar = TopBarWebView(type: .back)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.delegate = self
        view.addSubview(topBar)
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)
    }

    override func setupConstraints() {

        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewTraits.marginsTopBar.top),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            webView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func setupAccessibilityIdentifiers() {
        
    }

    // MARK: - Actions

    // MARK: Private Methods
    func load(urlRequest: URLRequest) {
        webView.load(urlRequest)
    }
}

// MARK: - BankAuthViewControllerProtocol
extension BankAuthViewController: BankAuthViewControllerProtocol {
    
    func updateAuthUrl(with url: URL) {
        load(urlRequest: URLRequest(url: url))
    }
}

extension BankAuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Called when the web view begins to receive web content")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Called when web content begins to load in a web view")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Called when the navigation is complete")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else { decisionHandler(.allow); return }
        guard let components: URLComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let _ = components.host else {
                decisionHandler(.allow)
                return
        }
        presenter.getTokens(components: components)
        decisionHandler(.allow)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("Called when the web view’s web content process is terminated")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Called when an error occurs during navigation")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Called when an error occurs while the web view is loading content")
    }
}

// MARK: - TopBar Delegate
extension BankAuthViewController: TopBarWebViewDelegate {
    func topBarWebView(_ topBarWebView: TopBarWebView, didPressItem item: Button) {
        
        self.presenter.topBarButtonPressed()
    }
}
