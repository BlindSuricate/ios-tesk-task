//
//  AddTransactionContentView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class AddTransactionContentView: UIView {
    
    // MARK: - Handlers
    var onSaveTransactionHandler: ((Transaction) -> Void)?
    var onCancelHandler: (() -> Void)?
    
    // MARK: - Subviews
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField().prepareForAutolayout()
        textField.placeholder = "Enter amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        return textField
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.text = "Add New Transaction"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.textColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system).prepareForAutolayout()
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AddTransactionContentView {
    // MARK: - Actions
    @objc func cancelTapped() {
        onCancelHandler?()
    }
    
    @objc func saveTapped() {
        let transaction = Transaction(category: .electronics, amount: 123)
        onSaveTransactionHandler?(transaction)
    }
    
    // MARK: - Private Methods
    func setupConstraints() {
        [titleLabel, amountTextField, errorLabel, saveButton].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            amountTextField.heightAnchor.constraint(equalToConstant: 44),
            
            errorLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            saveButton.heightAnchor.constraint(equalToConstant: 64)
            
        ])
    }
}

// MARK: - AddTransactionScreenViewProtocol
extension AddTransactionContentView: AddTransactionScreenViewProtocol {
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func clearFields() {
        amountTextField.text = ""
        errorLabel.isHidden = true
    }
}
