//
//  CornerRadiusConfig.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 07.10.2025.
//

import UIKit

// MARK: - Corner Radius Configuration
struct CornerRadiusConfig {
    let radius: CGFloat
    
    init(_ radius: CGFloat) {
        self.radius = radius
    }
}

// MARK: - Predefined Corner Radius Values
extension CornerRadiusConfig {
    
    static let small = CornerRadiusConfig(4)
    
    static let medium = CornerRadiusConfig(8)
    
    static let large = CornerRadiusConfig(12)
    
    static let extraLarge = CornerRadiusConfig(16)
    
    // MARK: - Custom Radius
    static func custom(_ radius: CGFloat) -> CornerRadiusConfig {
        CornerRadiusConfig(radius)
    }
}

// MARK: - UIView Extension for Corner Radius
extension UIView {
    func applyCornerRadius(_ config: CornerRadiusConfig) {
        layer.cornerRadius = config.radius
    }
    
    func applyCornerRadius(_ config: CornerRadiusConfig, clipsToBounds: Bool) {
        layer.cornerRadius = config.radius
        self.clipsToBounds = clipsToBounds
    }
}
