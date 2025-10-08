//
//  UIExtensions.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 07.10.2025.
//

import UIKit

// MARK: - UILabel Extension
extension UILabel {
    func setupStyle(_ style: TextStyle) {
        font = style.font
        textColor = style.color
        if let alignment = style.alignment {
            textAlignment = alignment
        }
    }
}

// MARK: - UIButton Extension
extension UIButton {
    func setupStyle(_ style: TextStyle) {
        titleLabel?.font = style.font
        setTitleColor(style.color, for: .normal)
    }
}
