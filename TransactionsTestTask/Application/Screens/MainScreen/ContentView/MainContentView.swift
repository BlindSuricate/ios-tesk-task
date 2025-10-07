//
//  MainContentView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class MainContentView: UIView {
    
    // MARK: - Handlers
    var onAddTransactionHandler: (() -> Void)?
    var onTopUpBalanceHandler: (() -> Void)?
    
    //MARK: - Constants
    private enum Constants {
        static let currentBalanceViewHeight: CGFloat = 250
    }
    
    // MARK: - Subviews
    private lazy var currentBalanceView: CurrentBalanceView = {
        let view = CurrentBalanceView().prepareForAutolayout()
        return view
    }()

    private lazy var transactionsContainerView: CornerView = {
        let view = CornerView().prepareForAutolayout()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()

    private(set) lazy var transactionsTableView: UITableView = {
        let tableView = UITableView().prepareForAutolayout()
        tableView.register(TransactionCell.self)
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    

    // MARK: - Constraints
    private var containerTopConstraint: NSLayoutConstraint!

    // MARK: - Layout Metrics
    private var collapsedTopAnchor: CGFloat {
        return 16 + Constants.currentBalanceViewHeight + 72
    }

    private var expandedTopAnchor: CGFloat {
        return safeAreaInsets.top
    }

    // MARK: - Gesture Tracking
    private var panStartY: CGFloat = 0
    private var containerStartTop: CGFloat = 0

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setupConstraints()
        setupGesture()
        setupHandlers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        if containerTopConstraint.constant < collapsedTopAnchor {
            containerTopConstraint.constant = expandedTopAnchor
        }
    }
}

extension MainContentView {
    
    // MARK: - Constraints
    private func setupConstraints() {
        
        [currentBalanceView, transactionsContainerView].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            currentBalanceView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            currentBalanceView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            currentBalanceView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            currentBalanceView.heightAnchor.constraint(equalToConstant: Constants.currentBalanceViewHeight)
        ])

        containerTopConstraint = transactionsContainerView.topAnchor.constraint(equalTo: topAnchor, constant: collapsedTopAnchor)
        NSLayoutConstraint.activate([
            containerTopConstraint,
            transactionsContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            transactionsContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            transactionsContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        transactionsContainerView.addSubview(transactionsTableView)
        NSLayoutConstraint.activate([
            transactionsTableView.topAnchor.constraint(equalTo: transactionsContainerView.topAnchor, constant: 16),
            transactionsTableView.leadingAnchor.constraint(equalTo: transactionsContainerView.leadingAnchor),
            transactionsTableView.trailingAnchor.constraint(equalTo: transactionsContainerView.trailingAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: transactionsContainerView.bottomAnchor)
        ])
        
    }

    // MARK: - Setup
    private func setupHandlers() {
        currentBalanceView.onAddTransactionHandler = { [weak self] in
            self?.onAddTransactionHandler?()
        }
        
        currentBalanceView.onTopUpBalanceHandler = { [weak self] in
            self?.onTopUpBalanceHandler?()
        }
    }
    
    // MARK: - Gesture Handling
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan)
        )
        transactionsContainerView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            panStartY = gesture.location(in: self).y
            containerStartTop = containerTopConstraint.constant
        case .changed:
            let currentY = gesture.location(in: self).y
            let delta = currentY - panStartY
            var newTop = containerStartTop + delta
            newTop = max(
                expandedTopAnchor,
                min(
                    newTop,
                    collapsedTopAnchor
                )
            )
            containerTopConstraint.constant = newTop
        case .ended, .cancelled, .failed:
            let midPoint = (collapsedTopAnchor + expandedTopAnchor) / 2
            let finalTop: CGFloat = containerTopConstraint.constant < midPoint ? expandedTopAnchor : collapsedTopAnchor
            animateContainer(to: finalTop)
        default:
            break
        }
    }
    

    //MARK: -Animations
    private func animateContainer(to top: CGFloat) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut]
        ) {
            self.containerTopConstraint.constant = top
            self.layoutIfNeeded()
        }
    }
}

// MARK: - MainScreenViewProtocol
extension MainContentView: MainScreenViewProtocol {
    
    func updateTransactionSections(_ sections: [TransactionSection]) {
        reloadTableView()
    }
    
    func reloadTableView() {
        transactionsTableView.reloadData()
    }
    
    func updateBitcoinRate(_ rate: Double) {
        currentBalanceView.updateBitcoinRate(rate)
    }
    
    func updateBitcoinRateWithDate(_ rate: Double, date: Date) {
        currentBalanceView.updateBitcoinRateWithDate(rate, date: date)
    }
    
    func showBitcoinLoading() {
        currentBalanceView.showBitcoinLoading()
    }
    
    func showBitcoinError() {
        currentBalanceView.showBitcoinError()
    }
    
    func updateBalance(_ amount: Double) {
        currentBalanceView.updateBalance(amount)
    }
    
    func updateBalance(_ currentBalance: CurrentBalance) {
        currentBalanceView.updateBalance(currentBalance)
    }
}

