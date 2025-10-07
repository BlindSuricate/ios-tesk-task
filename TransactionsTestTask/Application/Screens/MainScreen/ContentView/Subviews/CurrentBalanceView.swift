//
//  CurrentBalanceView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class CurrentBalanceView: CornerView {
    
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
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [balanceLabel, balanceAmountLabel, bitcoinRateLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillProportionally
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
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Public Methods
    func updateBitcoinRate(_ rate: Double) {
        bitcoinRateLabel.text = "Bitcoin: $\(String(format: "%.2f", rate))"
    }
    
    func updateBalance(_ amount: Double) {
        balanceAmountLabel.text = "$\(String(format: "%.2f", amount))"
    }
    
    func showBitcoinLoading() {
        bitcoinRateLabel.text = "Bitcoin: Loading..."
    }
    
    func showBitcoinError() {
        bitcoinRateLabel.text = "Bitcoin: Error loading rate"
        bitcoinRateLabel.textColor = .systemRed
    }
}
