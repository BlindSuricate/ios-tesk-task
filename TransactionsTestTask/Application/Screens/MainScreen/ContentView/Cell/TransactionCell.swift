//
//  TransactionCell.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class TransactionCell: UITableViewCell {
    
    // MARK: - Constants
    private enum Constants {
        static let cellHeight: CGFloat = 100
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
        static let spacing: CGFloat = 8
    }
    
    // MARK: - UI Elements
    private lazy var timeLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.setupStyle(.timeLabel)
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.setupStyle(.categoryLabel)
        return label
    }()
    
    private lazy var bitcoinAmountLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.setupStyle(.bitcoinAmountLabel)
        return label
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            timeLabel,
            categoryLabel]
        ).prepareForAutolayout()
        stack.axis = .vertical
        stack.spacing = Constants.spacing
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            bitcoinAmountLabel
        ]).prepareForAutolayout()
        stack.axis = .vertical
        stack.spacing = Constants.spacing
        stack.alignment = .trailing
        stack.distribution = .fillProportionally
        return stack
    }()
    
    // MARK: - Properties
    private var currentBitcoinRate: Double = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension TransactionCell {
    private func setupUI() {
        backgroundColor = .white
        selectionStyle = .none
        
        addSubview(leftStackView)
        addSubview(rightStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            leftStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            leftStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftStackView.trailingAnchor.constraint(lessThanOrEqualTo: rightStackView.leadingAnchor, constant: -Constants.horizontalPadding),
            
            rightStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            rightStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leftStackView.trailingAnchor, constant: Constants.horizontalPadding),
        ])
    }
}

// MARK: - ConfigurableCell
extension TransactionCell: ConfigurableCell {
    func configure(with model: Transaction) {
        timeLabel.text = model.date.shortTimeString
        categoryLabel.text = model.category.displayTitle
        configureAmountLabel(for: model)
    }
}

// MARK: - Private Methods
extension TransactionCell {
    private func configureAmountLabel(for transaction: Transaction) {
        let isIncome = transaction.category.isEnrollment
        let sign = isIncome ? "+" : "-"
        let amountText = "\(sign)\(transaction.amount)"
        
        bitcoinAmountLabel.text = amountText
        if isIncome {
            bitcoinAmountLabel.setupStyle(.incomeAmountLabel)
        } else {
            bitcoinAmountLabel.setupStyle(.expenseAmountLabel)
        }
    }
}
