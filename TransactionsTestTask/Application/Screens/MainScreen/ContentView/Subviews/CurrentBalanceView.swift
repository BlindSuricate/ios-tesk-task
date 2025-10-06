//
//  CurrentBalanceView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class CurrentBalanceView: CornerView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CurrentBalanceView {
    private func setupConstraints() {
        backgroundColor = .yellow
    }
}
