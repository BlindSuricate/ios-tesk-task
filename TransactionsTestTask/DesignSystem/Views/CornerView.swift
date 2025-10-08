//
//  CornerView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

class CornerView: UIView {
    
    init(cornerRadius: CornerRadiusConfig = .extraLarge) {
        super.init(frame: .zero)
        applyCornerRadius(cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
