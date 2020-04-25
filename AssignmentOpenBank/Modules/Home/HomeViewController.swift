//
//  HomeViewController.swift
//  AssignmentOpenBank
//
//  Created by pips on 19/12/2019.
//  Copyright © 2019 pips. All rights reserved.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    override var prefersNavigationBarHidden: Bool { return true }

    var presenter: HomePresenterProtocol!

    // MARK: - Component Declaration
    private let itemsPerColumn: CGFloat = 1
    private let cardsHeight: CGFloat = 160
    private let innerHeightMargin: CGFloat = 10
    private let sectionInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)

    private enum ViewTraits {
        static let margins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        static let buttonMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private var titleLabel: Label!
    private var accountsCollectionView: UICollectionView!
    private var accountsPageControl: UIPageControl!
    private var transactionsTitleLabel: Label!
    private var transactionsTableView: UITableView!
    private var sendButton: Button!
    
    private var viewModel: Home.ViewModel = Home.ViewModel(imageUrl: "", accounts: [], transactions: [])
    
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
        
        presenter.prepareView()
    }
    
    // MARK: - Setup

    override func setupComponents() {

        view.backgroundColor = .white
        
        titleLabel = Label(style: .title1, text: "Cuenta")
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.headerReferenceSize = CGSize(width: 0.0, height: cardsHeight)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        accountsCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        accountsCollectionView.backgroundColor = .appWhite
        accountsCollectionView.alwaysBounceVertical = false
        accountsCollectionView.alwaysBounceHorizontal = false
        accountsCollectionView.isPagingEnabled = true
        accountsCollectionView.showsHorizontalScrollIndicator = false
        accountsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        accountsCollectionView.dataSource = self
        accountsCollectionView.delegate = self
        accountsCollectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.cellIdentifier)
        accountsCollectionView.register(CarouselAddMoreCollectionViewCell.self, forCellWithReuseIdentifier: CarouselAddMoreCollectionViewCell.cellIdentifier)
        view.addSubview(accountsCollectionView)
        
        accountsPageControl = UIPageControl()
        accountsPageControl.numberOfPages = 0
        accountsPageControl.currentPage = 0
        accountsPageControl.tintColor = .appWhite
        accountsPageControl.pageIndicatorTintColor = .appLigthGrey
        accountsPageControl.currentPageIndicatorTintColor = .appOrange
        accountsPageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountsPageControl)
        
        transactionsTitleLabel = Label(style: .title1, text: "Transacciones")
        transactionsTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        transactionsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(transactionsTitleLabel)
        
        transactionsTableView = UITableView(frame: CGRect.zero, style: .plain)
        transactionsTableView.translatesAutoresizingMaskIntoConstraints = false
        transactionsTableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.cellIdentifier)
        transactionsTableView.estimatedRowHeight = 100
        transactionsTableView.rowHeight = UITableView.automaticDimension
        transactionsTableView.separatorStyle = .none
        transactionsTableView.dataSource = self
        transactionsTableView.delegate = self
        view.addSubview(transactionsTableView)
        
        sendButton = Button(style: .tertiary)
        sendButton.addTarget(self, action: #selector(sendMoneyTapped), for: .touchUpInside)
        sendButton.title = "Enviar"
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
    }

    override func setupConstraints() {

        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewTraits.margins.left),
            
            accountsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewTraits.margins.left),
            accountsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewTraits.margins.right),
            accountsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: innerHeightMargin),
            accountsCollectionView.heightAnchor.constraint(equalToConstant: cardsHeight),
            
            accountsPageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewTraits.margins.left),
            accountsPageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ViewTraits.margins.right),
            accountsPageControl.topAnchor.constraint(equalTo: accountsCollectionView.bottomAnchor),
            
            transactionsTitleLabel.topAnchor.constraint(equalTo: accountsPageControl.bottomAnchor),
            transactionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ViewTraits.margins.left),
            
            transactionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transactionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transactionsTableView.topAnchor.constraint(equalTo: transactionsTitleLabel.bottomAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: sendButton.topAnchor),
            
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func setupAccessibilityIdentifiers() {
        
    }

    // MARK: - Actions

    @objc private func sendMoneyTapped() {
        
        self.presenter.sendMoney()
    }
    
    @objc private func requestMoneyTapped() {
        
//        self.presenter.requestMoney()
    }
    
    // MARK: Private Methods

}

// MARK: - HomeViewControllerProtocol
extension HomeViewController: HomeViewControllerProtocol {
    
    func updateView(viewModel: Home.ViewModel) {
        
        self.viewModel = viewModel
        self.accountsPageControl.numberOfPages = viewModel.accounts.count + 1
        self.accountsPageControl.currentPage = 0
        self.accountsCollectionView.reloadData()
        self.transactionsTableView.reloadData()
    }
}

// MARK: - CollectionView Delegate and Data Source
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.accounts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.row == viewModel.accounts.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselAddMoreCollectionViewCell.cellIdentifier, for: indexPath) as? CarouselAddMoreCollectionViewCell else {
                return CarouselAddMoreCollectionViewCell()
            }
            
            cell.image = UIImage(named: "add_icon")
            cell.text = "Añadir cuenta"
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.cellIdentifier, for: indexPath) as? CarouselCollectionViewCell else {
                return CarouselCollectionViewCell()
            }
            let bankAccount = viewModel.accounts[indexPath.row]
            cell.cardView.color = bankAccount.primaryColor
            cell.cardView.title = bankAccount.balance
            cell.cardView.subtitle = bankAccount.accountName
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let availableWidth = view.frame.width - (ViewTraits.margins.right + ViewTraits.margins.left)
        
        return CGSize(width: availableWidth, height: cardsHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.accountsPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        presenter.selectPayment()
    }
}

// MARK: - TableView Delegate and Data Source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.cellIdentifier, for: indexPath) as? TransactionTableViewCell else {
            fatalError("Remember to register cellIdentifier")
        }
        let transaction = viewModel.transactions[indexPath.row]
        
        cell.leftImage = UIImage(named: "default_avatar")
        cell.title = transaction.username
        cell.subtitle = transaction.date
        cell.subTitleColor = .gray
        cell.amount = transaction.amount
        cell.amountColor = .appBlack
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.presenter.transferSelected(atIndex: indexPath.row)
    }
}
