//
//  UIView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

extension UIView {
    @discardableResult
    func prepareForAutolayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
