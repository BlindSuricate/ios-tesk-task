//
//  CurrentBalanceView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class CurrentBalanceView: CornerView {
    
    // MARK: - Properties
    var onAddTransactionHandler: (() -> Void)?
    var onTopUpBalanceHandler: (() -> Void)?
    
    // MARK: - UI Elements
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Balance"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bitcoinRateLabel: UILabel = {
        let label = UILabel()
        label.text = "Bitcoin: Loading..."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bitcoinRateDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Add Transaction", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var topUpBalanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("💰 Top Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(topUpBalanceTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addTransactionButton, topUpBalanceButton])
        stack.axis = .horizontal
        stack.spacing = 12
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
        stack.spacing = 12
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
        stack.spacing = 4
        stack.alignment = .trailing
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        layer.cornerRadius = 12
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
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            
            bitcoinRateStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            bitcoinRateStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            addTransactionButton.heightAnchor.constraint(equalToConstant: 44),
            topUpBalanceButton.heightAnchor.constraint(equalToConstant: 44),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 320)
        ])
    }
    
    // MARK: - Public Methods
    func updateBitcoinRate(_ rate: Double) {
        bitcoinRateLabel.text = "Bitcoin: $\(String(format: "%.2f", rate))"
        bitcoinRateDateLabel.text = "Updated: \(formatDate(Date()))"
        bitcoinRateLabel.textColor = .systemBlue
    }
    
    func updateBitcoinRateWithDate(_ rate: Double, date: Date) {
        bitcoinRateLabel.text = "Bitcoin: $\(String(format: "%.2f", rate))"
        bitcoinRateDateLabel.text = "Updated: \(formatDate(date))"
        bitcoinRateLabel.textColor = .systemBlue
    }
    
    func updateBalance(_ amount: Double) {
        balanceAmountLabel.text = "\(String(format: "%.5f", amount)) BTC"
    }
    
    func updateBalance(_ currentBalance: CurrentBalance) {
        balanceAmountLabel.text = "\(String(format: "%.5f", currentBalance.balance)) BTC"
    }
    
    func showBitcoinLoading() {
        bitcoinRateLabel.text = "Bitcoin: Loading..."
        bitcoinRateDateLabel.text = ""
        bitcoinRateLabel.textColor = .systemBlue
    }
    
    func showBitcoinError() {
        bitcoinRateLabel.text = "Bitcoin: Error loading rate"
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
    
    // MARK: - Private Methods
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
