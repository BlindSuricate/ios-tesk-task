//
//  TextStyle.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 07.10.2025.
//

import UIKit

// MARK: - TextStyle
struct TextStyle {
    let font: UIFont
    let color: UIColor
    let alignment: NSTextAlignment?
    
    init(font: UIFont, color: UIColor, alignment: NSTextAlignment? = nil) {
        self.font = font
        self.color = color
        self.alignment = alignment
    }
}

// MARK: - Predefined Styles
extension TextStyle {
    
    // MARK: - Title Styles
    static let title = TextStyle(
        font: UIFont.systemFont(ofSize: 24, weight: .bold),
        color: .label,
        alignment: .center
    )
    
    // MARK: - Label Styles
    static let label = TextStyle(
        font: UIFont.systemFont(ofSize: 16, weight: .medium),
        color: .label
    )
    
    static let errorLabel = TextStyle(
        font: UIFont.systemFont(ofSize: 14),
        color: .systemRed,
        alignment: .center
    )
    
    // MARK: - Button Styles
    static let button = TextStyle(
        font: UIFont.systemFont(ofSize: 16),
        color: .label
    )
    
    static let saveButton = TextStyle(
        font: UIFont.systemFont(ofSize: 18, weight: .semibold),
        color: .white
    )
    
    // MARK: - TextField Styles
    static let textField = TextStyle(
        font: UIFont.systemFont(ofSize: 16),
        color: .label
    )
    
    // MARK: - TransactionCell Styles
    static let timeLabel = TextStyle(
        font: UIFont.systemFont(ofSize: 16, weight: .medium),
        color: .black,
        alignment: .left
    )
    
    static let categoryLabel = TextStyle(
        font: UIFont.systemFont(ofSize: 14, weight: .bold),
        color: .systemGray,
        alignment: .left
    )
    
    static let bitcoinAmountLabel = TextStyle(
        font: UIFont.systemFont(ofSize: 18, weight: .bold),
        color: .systemOrange,
        alignment: .right
    )
    
    // MARK: - Transaction Amount Styles
    static let incomeAmountLabel = TextStyle(
        font: UIFont.systemFont(ofSize: 18, weight: .bold),
        color: .systemGreen,
        alignment: .right
    )
    
    static let expenseAmountLabel = TextStyle(
        font: UIFont.systemFont(ofSize: 18, weight: .bold),
        color: .systemRed,
        alignment: .right
    )
    
    // MARK: - CurrentBalanceView Styles
    static let balanceLabel = TextStyle(
        font: UIFont.systemFont(ofSize: 18, weight: .medium),
        color: .darkGray,
        alignment: .center
    )
    
    static let balanceAmountLabel = TextStyle(
        font: UIFont.systemFont(ofSize: 32, weight: .bold),
        color: .black,
        alignment: .center
    )
    
    static let bitcoinRateLabel = TextStyle(
        font: UIFont.systemFont(ofSize: 14, weight: .regular),
        color: .systemBlue,
        alignment: .center
    )
    
    static let bitcoinRateDateLabel = TextStyle(
        font: UIFont.systemFont(ofSize: 12, weight: .light),
        color: .systemGray,
        alignment: .center
    )
    
    static let actionButton = TextStyle(
        font: UIFont.systemFont(ofSize: 16, weight: .semibold),
        color: .white
    )
}
