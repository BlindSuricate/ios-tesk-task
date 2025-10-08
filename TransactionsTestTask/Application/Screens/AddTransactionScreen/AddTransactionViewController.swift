//
//  AddTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let pickerTag = 999
        static let pickerHeight: CGFloat = 162
    }
    
    private let presenter: AddTransactionScreenPresenterProtocol
    private var contentView: AddTransactionContentView!
    
    struct Dependencies {
        let presenter: AddTransactionScreenPresenterProtocol
    }
    
    init(dependencies: Dependencies) {
        self.presenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = AddTransactionContentView()
        self.contentView = view
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHandlers()
        presenter.loadView(controller: self)
        presenter.viewDidLoad()
    }
    
    private func setupViewHandlers() {
        contentView.onSaveTransactionHandler = { [weak self] transaction in
            self?.presenter.saveTransactionTapped(transaction)
        }
        
        contentView.onCategoryButtonTappedHandler = { [weak self] in
            self?.presenter.categoryButtonTapped()
        }
    }
}

// MARK: - AddTransactionScreenViewControllerProtocol
extension AddTransactionViewController: AddTransactionScreenViewControllerProtocol {
    
    func showError(_ message: String) {
        contentView.showError(message)
    }
    
    func clearFields() {
        contentView.clearFields()
    }
    
    func showCategoryPicker() {
        let categories = TransactionCategory.expenseTransaction
        let pickerViewController = UIViewController()
        pickerViewController.view.backgroundColor = .clear
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = Constants.pickerTag
        
        pickerViewController.view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: pickerViewController.view.topAnchor),
            pickerView.leadingAnchor.constraint(equalTo: pickerViewController.view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: pickerViewController.view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: pickerViewController.view.bottomAnchor),
            pickerViewController.view.heightAnchor.constraint(equalToConstant: Constants.pickerHeight)
        ])
        
        if let selectedIndex = categories.firstIndex(of: contentView.selectedCategory) {
            pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
        
        let alert = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        alert.setValue(pickerViewController, forKey: "contentViewController")
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] _ in
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            if selectedRow < categories.count {
                let selectedCategory = categories[selectedRow]
                self?.contentView.updateSelectedCategory(selectedCategory)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = contentView.categoryButton
            popover.sourceRect = contentView.categoryButton.bounds
        }
        
        present(alert, animated: true)
    }
}

// MARK: - UIPickerViewDataSource
extension AddTransactionViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        TransactionCategory.expenseTransaction.count
    }
}

// MARK: - UIPickerViewDelegate
extension AddTransactionViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        TransactionCategory.expenseTransaction[row].title
    }
}
