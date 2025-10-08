//
//  AddTransactionContentView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class AddTransactionContentView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        // MARK: - Layout
        static let topInset: CGFloat = 32
        static let bottomInset: CGFloat = 32
        static let leadingInset: CGFloat = 24
        static let trailingInset: CGFloat = 24
        static let stackSpacing: CGFloat = 16
        
        // MARK: - Component Heights
        static let textFieldHeight: CGFloat = 44
        static let buttonHeight: CGFloat = 44
        static let saveButtonHeight: CGFloat = 50
        
        // MARK: - Text Constants
        static let titleText = "Add New Transaction"
        static let amountLabelText = "Amount (USD)"
        static let categoryLabelText = "Category"
        static let selectCategoryButtonText = "Select Category"
        static let saveTransactionButtonText = "Save Transaction"
        static let valideAmountError = "Please enter a valid amount"
        static let amountTextFieldPlaceholder = "Enter amount"
    }
    
    // MARK: - Handlers
    var onSaveTransactionHandler: ((Transaction) -> Void)?
    var onCategoryButtonTappedHandler: (() -> Void)?
    
    // MARK: - Properties
    var selectedCategory: TransactionCategory = .other
    private let categories = TransactionCategory.expenseTransaction
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.text = Constants.titleText
        label.setupStyle(.title)
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.text = Constants.amountLabelText
        label.setupStyle(.label)
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField().prepareForAutolayout()
        textField.placeholder = Constants.amountTextFieldPlaceholder
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.font = TextStyle.textField.font
        textField.textColor = TextStyle.textField.color
        textField.addTarget(self, action: #selector(amountTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.text = Constants.categoryLabelText
        label.setupStyle(.label)
        return label
    }()
    
    lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system).prepareForAutolayout()
        button.setTitle(Constants.selectCategoryButtonText, for: .normal)
        button.setupStyle(.button)
        button.backgroundColor = .systemGray6
        button.applyCornerRadius(.medium)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.setupStyle(.errorLabel)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system).prepareForAutolayout()
        button.setTitle(Constants.saveTransactionButtonText, for: .normal)
        button.setupStyle(.saveButton)
        button.backgroundColor = .systemGray4
        button.applyCornerRadius(.large)
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            amountLabel,
            amountTextField,
            categoryLabel,
            categoryButton,
            errorLabel,
            saveButton
        ])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        updateSaveButtonState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension AddTransactionContentView {
    func setupUI() {
        addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.topInset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.leadingInset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.trailingInset),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.bottomInset),
            
            amountTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            categoryButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.saveButtonHeight)
        ])
    }
}

// MARK: - Actions
private extension AddTransactionContentView {
    
    @objc func saveTapped() {
        guard let amountText = amountTextField.text,
              let amount = Double(amountText),
              amount > 0 else {
            showError(Constants.valideAmountError)
            return
        }
        
        let transaction = Transaction(category: selectedCategory, amount: amount)
        onSaveTransactionHandler?(transaction)
    }
    
    @objc func amountTextFieldChanged() {
        updateSaveButtonState()
        hideError()
    }
    
    @objc func categoryButtonTapped() {
        onCategoryButtonTappedHandler?()
    }
}

// MARK: - Private Methods
private extension AddTransactionContentView {
    func updateSaveButtonState() {
        let hasValidAmount = !(amountTextField.text?.isEmpty ?? true) && 
                           Double(amountTextField.text ?? "") != nil &&
                           (Double(amountTextField.text ?? "") ?? 0) > 0
        
        let hasSelectedCategory = categoryButton.title(for: .normal) != Constants.selectCategoryButtonText
        
        let isFormValid = hasValidAmount && hasSelectedCategory
        
        saveButton.isEnabled = isFormValid
        saveButton.backgroundColor = isFormValid ? .systemBlue : .systemGray4
    }
    
    
    
    func hideError() {
        errorLabel.isHidden = true
    }
}

//MARK: - Public methods
extension AddTransactionContentView {
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func updateSelectedCategory(_ category: TransactionCategory) {
        selectedCategory = category
        categoryButton.setTitle(category.title, for: .normal)
        updateSaveButtonState()
    }
}

// MARK: - AddTransactionScreenViewProtocol
extension AddTransactionContentView: AddTransactionScreenViewProtocol {
    func clearFields() {
        amountTextField.text = ""
        selectedCategory = .other
        categoryButton.setTitle(Constants.selectCategoryButtonText, for: .normal)
        errorLabel.isHidden = true
        updateSaveButtonState()
    }
}

