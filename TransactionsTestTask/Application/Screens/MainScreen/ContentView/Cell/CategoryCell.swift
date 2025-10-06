//
//  CategoryCell.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit.UITableViewCell

final class TransactionCell: UITableViewCell {
    //MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.text = "CategoryName"
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TransactionCell {
    private func setupConstraints() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension TransactionCell: ConfigurableCell {
    func configure(with model: Transaction) {
        titleLabel.text = model.category.rawValue
    }
}
