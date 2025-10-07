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
    
    // MARK: - Properties
    private var selectedCategory: TransactionCategory = .other
    private let categories = TransactionCategory.expenseTransaction
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.text = "Add New Transaction"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.text = "Amount (USD)"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField().prepareForAutolayout()
        textField.placeholder = "Enter amount"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.addTarget(self, action: #selector(amountTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel().prepareForAutolayout()
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system).prepareForAutolayout()
        button.setTitle("Select Category", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var categoryPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
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
        button.setTitle("Save Transaction", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 12
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
        stack.spacing = 16
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
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            
            amountTextField.heightAnchor.constraint(equalToConstant: 44),
            categoryButton.heightAnchor.constraint(equalToConstant: 44),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Actions
private extension AddTransactionContentView {
    
    @objc func saveTapped() {
        guard let amountText = amountTextField.text,
              let amount = Double(amountText),
              amount > 0 else {
            showError("Please enter a valid amount")
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
        showCategoryPicker()
    }
}

// MARK: - Private Methods
private extension AddTransactionContentView {
    func updateSaveButtonState() {
        let hasValidAmount = !(amountTextField.text?.isEmpty ?? true) && 
                           Double(amountTextField.text ?? "") != nil &&
                           (Double(amountTextField.text ?? "") ?? 0) > 0
        
        let hasSelectedCategory = categoryButton.title(for: .normal) != "Select Category"
        
        let isFormValid = hasValidAmount && hasSelectedCategory
        
        saveButton.isEnabled = isFormValid
        saveButton.backgroundColor = isFormValid ? .systemBlue : .systemGray4
    }
    
    func showCategoryPicker() {
        let pickerViewController = UIViewController()
        pickerViewController.view.backgroundColor = .clear
        
        pickerViewController.view.addSubview(categoryPickerView)
        categoryPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryPickerView.topAnchor.constraint(equalTo: pickerViewController.view.topAnchor),
            categoryPickerView.leadingAnchor.constraint(equalTo: pickerViewController.view.leadingAnchor),
            categoryPickerView.trailingAnchor.constraint(equalTo: pickerViewController.view.trailingAnchor),
            categoryPickerView.bottomAnchor.constraint(equalTo: pickerViewController.view.bottomAnchor),
            pickerViewController.view.heightAnchor.constraint(equalToConstant: 162)
        ])
        
        if let selectedIndex = categories.firstIndex(of: selectedCategory) {
            categoryPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
        
        let alert = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        alert.setValue(pickerViewController, forKey: "contentViewController")
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] _ in
            let selectedRow = self?.categoryPickerView.selectedRow(inComponent: 0) ?? 0
            if selectedRow < self?.categories.count ?? 0 {
                self?.selectedCategory = self?.categories[selectedRow] ?? .other
                self?.categoryButton.setTitle(self?.selectedCategory.title, for: .normal)
                self?.updateSaveButtonState()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = categoryButton
            popover.sourceRect = categoryButton.bounds
        }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            var topController = rootViewController
            while let presentedController = topController.presentedViewController {
                topController = presentedController
            }
            topController.present(alert, animated: true)
        }
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
}

// MARK: - AddTransactionScreenViewProtocol
extension AddTransactionContentView: AddTransactionScreenViewProtocol {
    func clearFields() {
        amountTextField.text = ""
        selectedCategory = .other
        categoryButton.setTitle("Select Category", for: .normal)
        errorLabel.isHidden = true
        updateSaveButtonState()
    }
}

// MARK: - UIPickerViewDataSource
extension AddTransactionContentView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
}

// MARK: - UIPickerViewDelegate
extension AddTransactionContentView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[row].title
    }
}
