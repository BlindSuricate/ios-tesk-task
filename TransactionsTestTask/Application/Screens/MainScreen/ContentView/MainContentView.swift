//
//  MainContentView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class MainContentView: UIView {
    
    //MARK: - Constants
    private enum Constants {
        // MARK: - Layout
        static let currentBalanceViewHeight: CGFloat = 250
        static let inset: CGFloat = 16
        static let topInset: CGFloat = 16
        static let bottomInset: CGFloat = 16
        static let leadingInset: CGFloat = 16
        static let trailingInset: CGFloat = 16
        
        // MARK: - Animation
        static let animationDuration: TimeInterval = 0.3
        static let springDamping: CGFloat = 0.8
        static let springVelocity: CGFloat = 0.5
        
        // MARK: - Layout Calculations
        static let collapsedTopOffset: CGFloat = 72
        
        // MARK: - Pagination Loading
        static let paginationLoadingHeight: CGFloat = 60
        static let paginationSpacing: CGFloat = 8
        
        // MARK: - Drag Indicator
        static let dragIndicatorWidth: CGFloat = 36
        static let dragIndicatorHeight: CGFloat = 4
        static let dragIndicatorTopOffset: CGFloat = 8
        
        // MARK: - Font Sizes
        static let paginationLabelFontSize: CGFloat = 14
        
        // MARK: - Text Constants
        static let paginationLoadingText = "Loading more transactions..."
    }
    
    // MARK: - Handlers
    var onAddTransactionHandler: (() -> Void)?
    var onTopUpBalanceHandler: (() -> Void)?
    
    // MARK: - Subviews
    private lazy var currentBalanceView: CurrentBalanceView = {
        let view = CurrentBalanceView(cornerRadius: .large).prepareForAutolayout()
        return view
    }()

    private lazy var transactionsContainerView: CornerView = {
        let view = CornerView().prepareForAutolayout()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dragIndicatorView: UIView = {
        let view = UIView().prepareForAutolayout()
        view.backgroundColor = .systemGray4
        view.applyCornerRadius(.custom(2))
        return view
    }()

    private(set) lazy var transactionsTableView: UITableView = {
        let tableView = UITableView().prepareForAutolayout()
        tableView.register(TransactionCell.self)
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var paginationLoadingView: UIView = {
        let view = UIView().prepareForAutolayout()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private lazy var paginationActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .systemGray
        return indicator
    }()
    
    private lazy var paginationLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.text = Constants.paginationLoadingText
        label.font = UIFont.systemFont(ofSize: Constants.paginationLabelFontSize, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    

    // MARK: - Constraints
    private var containerTopConstraint: NSLayoutConstraint!

    // MARK: - Layout Metrics
    private var collapsedTopAnchor: CGFloat {
        return Constants.topInset + Constants.currentBalanceViewHeight + Constants.collapsedTopOffset
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
            currentBalanceView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topInset),
            currentBalanceView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.leadingInset),
            currentBalanceView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.trailingInset),
            currentBalanceView.heightAnchor.constraint(equalToConstant: Constants.currentBalanceViewHeight)
        ])

        containerTopConstraint = transactionsContainerView.topAnchor.constraint(equalTo: topAnchor, constant: collapsedTopAnchor)
        NSLayoutConstraint.activate([
            containerTopConstraint,
            transactionsContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            transactionsContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            transactionsContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        transactionsContainerView.addSubview(dragIndicatorView)
        transactionsContainerView.addSubview(transactionsTableView)
        transactionsContainerView.addSubview(paginationLoadingView)
        
        paginationLoadingView.addSubview(paginationActivityIndicator)
        paginationLoadingView.addSubview(paginationLabel)
        
        NSLayoutConstraint.activate([
            dragIndicatorView.centerXAnchor.constraint(equalTo: transactionsContainerView.centerXAnchor),
            dragIndicatorView.topAnchor.constraint(equalTo: transactionsContainerView.topAnchor, constant: Constants.dragIndicatorTopOffset),
            dragIndicatorView.widthAnchor.constraint(equalToConstant: Constants.dragIndicatorWidth),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: Constants.dragIndicatorHeight),
            
            transactionsTableView.topAnchor.constraint(equalTo: dragIndicatorView.bottomAnchor, constant: Constants.inset),
            transactionsTableView.leadingAnchor.constraint(equalTo: transactionsContainerView.leadingAnchor),
            transactionsTableView.trailingAnchor.constraint(equalTo: transactionsContainerView.trailingAnchor),
            transactionsTableView.bottomAnchor.constraint(equalTo: paginationLoadingView.topAnchor),
            
            paginationLoadingView.leadingAnchor.constraint(equalTo: transactionsContainerView.leadingAnchor),
            paginationLoadingView.trailingAnchor.constraint(equalTo: transactionsContainerView.trailingAnchor),
            paginationLoadingView.bottomAnchor.constraint(equalTo: transactionsContainerView.bottomAnchor),
            paginationLoadingView.heightAnchor.constraint(equalToConstant: Constants.paginationLoadingHeight),
            
            paginationActivityIndicator.centerXAnchor.constraint(equalTo: paginationLoadingView.centerXAnchor),
            paginationActivityIndicator.topAnchor.constraint(equalTo: paginationLoadingView.topAnchor, constant: Constants.paginationSpacing),
            
            paginationLabel.centerXAnchor.constraint(equalTo: paginationLoadingView.centerXAnchor),
            paginationLabel.topAnchor.constraint(equalTo: paginationActivityIndicator.bottomAnchor, constant: Constants.paginationSpacing),
            paginationLabel.leadingAnchor.constraint(greaterThanOrEqualTo: paginationLoadingView.leadingAnchor, constant: Constants.inset),
            paginationLabel.trailingAnchor.constraint(lessThanOrEqualTo: paginationLoadingView.trailingAnchor, constant: -Constants.inset)
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
            withDuration: Constants.animationDuration,
            delay: 0,
            usingSpringWithDamping: Constants.springDamping,
            initialSpringVelocity: Constants.springVelocity,
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
    
    func showPaginationLoading() {
        paginationLoadingView.isHidden = false
        paginationActivityIndicator.startAnimating()
    }
    
    func hidePaginationLoading() {
        paginationLoadingView.isHidden = true
        paginationActivityIndicator.stopAnimating()
    }
}

