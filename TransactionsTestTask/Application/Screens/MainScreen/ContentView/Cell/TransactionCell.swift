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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
    }()
    
    private lazy var bitcoinAmountLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemOrange
        label.textAlignment = .right
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
    
    private lazy var separatorView: UIView = {
        let view = UIView().prepareForAutolayout()
        view.backgroundColor = .systemGray5
        return view
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
        addSubview(separatorView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            leftStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            leftStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftStackView.trailingAnchor.constraint(lessThanOrEqualTo: rightStackView.leadingAnchor, constant: -Constants.horizontalPadding),
            
            rightStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            rightStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leftStackView.trailingAnchor, constant: Constants.horizontalPadding),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalPadding),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalPadding),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

// MARK: - ConfigurableCell
extension TransactionCell: ConfigurableCell {
    func configure(with model: Transaction) {
        timeLabel.text = formatTime(model.date)
        categoryLabel.text = model.category.title
        bitcoinAmountLabel.text = model.amount.description
        
    }
}

// MARK: - Private Methods
extension TransactionCell {
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
