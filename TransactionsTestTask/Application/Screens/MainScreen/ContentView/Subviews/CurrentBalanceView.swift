//
//  CurrentBalanceView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class CurrentBalanceView: CornerView {
    
    // MARK: - Constants
    private enum Constants {
        static let mainStackSpacing: CGFloat = 12
        static let buttonsStackSpacing: CGFloat = 12
        static let bitcoinRateStackSpacing: CGFloat = 4
        static let buttonHeight: CGFloat = 44
        static let buttonsStackWidth: CGFloat = 320
        static let horizontalInset: CGFloat = 16
        static let topInset: CGFloat = 12
        static let trailingInset: CGFloat = 12
        
        // MARK: - Text Constants
        static let currentBalanceText = "Current Balance"
        static let defaultBalanceText = "$0.00"
        static let bitcoinLoadingText = "Bitcoin: Loading..."
        static let bitcoinErrorText = "Bitcoin: Error loading rate"
        static let addTransactionButtonText = "+ Add Transaction"
        static let topUpBalanceButtonText = "💰 Top Up"
        static let bitcoinRatePrefix = "Bitcoin: $"
        static let updatedPrefix = "Updated: "
        static let btcSuffix = " BTC"
    }
    
    // MARK: - Properties
    var onAddTransactionHandler: (() -> Void)?
    var onTopUpBalanceHandler: (() -> Void)?
    
    // MARK: - UI Elements
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.currentBalanceText
        label.setupStyle(.balanceLabel)
        return label
    }()
    
    private lazy var balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.defaultBalanceText
        label.setupStyle(.balanceAmountLabel)
        return label
    }()
    
    private lazy var bitcoinRateLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.bitcoinLoadingText
        label.setupStyle(.bitcoinRateLabel)
        return label
    }()
    
    private lazy var bitcoinRateDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.setupStyle(.bitcoinRateDateLabel)
        return label
    }()
    
    private lazy var addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.addTransactionButtonText, for: .normal)
        button.setupStyle(.actionButton)
        button.backgroundColor = .systemBlue
        button.applyCornerRadius(.medium)
        button.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var topUpBalanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.topUpBalanceButtonText, for: .normal)
        button.setupStyle(.actionButton)
        button.backgroundColor = .systemGreen
        button.applyCornerRadius(.medium)
        button.addTarget(self, action: #selector(topUpBalanceTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addTransactionButton, topUpBalanceButton])
        stack.axis = .horizontal
        stack.spacing = Constants.buttonsStackSpacing
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            balanceLabel, 
            balanceAmountLabel, 
            buttonsStackView
        ])
        stack.axis = .vertical
        stack.spacing = Constants.mainStackSpacing
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var bitcoinRateStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            bitcoinRateLabel,
            bitcoinRateDateLabel
        ])
        stack.axis = .vertical
        stack.spacing = Constants.bitcoinRateStackSpacing
        stack.alignment = .trailing
        return stack
    }()
    
    override init(cornerRadius: CornerRadiusConfig = .extraLarge) {
        super.init(cornerRadius: cornerRadius)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CurrentBalanceView {
    
    private func setupUI() {
        backgroundColor = .systemYellow
        applyCornerRadius(.large)
        addSubview(stackView)
        addSubview(bitcoinRateStackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        topUpBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        bitcoinRateStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.horizontalInset),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.horizontalInset),
            
            bitcoinRateStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topInset),
            bitcoinRateStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.trailingInset),
            
            addTransactionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            topUpBalanceButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            buttonsStackView.widthAnchor.constraint(equalToConstant: Constants.buttonsStackWidth)
        ])
    }
    
    // MARK: - Public Methods
    func updateBitcoinRate(_ rate: Double) {
        bitcoinRateLabel.text = "\(Constants.bitcoinRatePrefix)\(String(format: "%.2f", rate))"
        bitcoinRateDateLabel.text = "\(Constants.updatedPrefix)\(Date().shortDateTimeString)"
        bitcoinRateLabel.textColor = .systemBlue
    }
    
    func updateBitcoinRateWithDate(_ rate: Double, date: Date) {
        bitcoinRateLabel.text = "\(Constants.bitcoinRatePrefix)\(String(format: "%.2f", rate))"
        bitcoinRateDateLabel.text = "\(Constants.updatedPrefix)\(date.shortDateTimeString)"
        bitcoinRateLabel.textColor = .systemBlue
    }
    
    func updateBalance(_ amount: Double) {
        balanceAmountLabel.text = "\(String(format: "%.5f", amount))\(Constants.btcSuffix)"
    }
    
    func updateBalance(_ currentBalance: CurrentBalance) {
        balanceAmountLabel.text = "\(String(format: "%.5f", currentBalance.balance))\(Constants.btcSuffix)"
    }
    
    func showBitcoinLoading() {
        bitcoinRateLabel.text = Constants.bitcoinLoadingText
        bitcoinRateDateLabel.text = ""
        bitcoinRateLabel.textColor = .systemBlue
    }
    
    func showBitcoinError() {
        bitcoinRateLabel.text = Constants.bitcoinErrorText
        bitcoinRateDateLabel.text = ""
        bitcoinRateLabel.textColor = .systemRed
    }
    
    // MARK: - Actions
    @objc private func addTransactionTapped() {
        onAddTransactionHandler?()
    }
    
    @objc private func topUpBalanceTapped() {
        onTopUpBalanceHandler?()
    }
    
}
