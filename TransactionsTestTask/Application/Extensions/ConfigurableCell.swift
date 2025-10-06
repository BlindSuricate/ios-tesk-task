//
//  ConfigurableCell.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

protocol ConfigurableCell: ReusableView {
    associatedtype CellModel
    func configure(with model: CellModel)
}
