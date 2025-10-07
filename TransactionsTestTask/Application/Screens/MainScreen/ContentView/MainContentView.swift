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
    var onTransactionSelectedHandler: ((Int) -> Void)?
    
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
    
    private lazy var addTransactionButton: UIButton = {
        let button = UIButton(type: .system).prepareForAutolayout()
        button.setTitle("+ Add Transaction", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
        return button
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
        
        transactionsContainerView.addSubview(addTransactionButton)
        NSLayoutConstraint.activate([
            addTransactionButton.bottomAnchor.constraint(equalTo: transactionsContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addTransactionButton.leadingAnchor.constraint(equalTo: transactionsContainerView.leadingAnchor, constant: 16),
            addTransactionButton.trailingAnchor.constraint(equalTo: transactionsContainerView.trailingAnchor, constant: -16),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
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
    
    @objc private func addTransactionTapped() {
        onAddTransactionHandler?()
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
    func updateTransactions(_ transactions: [Transaction]) {
        reloadTableView()
    }
    
    func reloadTableView() {
        transactionsTableView.reloadData()
    }
    
    func updateBitcoinRate(_ rate: Double) {
        currentBalanceView.updateBitcoinRate(rate)
    }
    
    func showBitcoinLoading() {
        currentBalanceView.showBitcoinLoading()
    }
    
    func showBitcoinError() {
        currentBalanceView.showBitcoinError()
    }
}

