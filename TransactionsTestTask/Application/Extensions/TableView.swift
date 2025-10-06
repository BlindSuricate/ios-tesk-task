//
//  TableView.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

extension UITableView {
    
    /// register tableView cell from generic class
    func register<T: UITableViewCell>(_ cellType: T.Type) where T: ReusableView {
        register(
            cellType,
            forCellReuseIdentifier: cellType.reuseIdentifier
        )
    }
    
    /// register tableView headerFooetr view from generic class
    func register<T: UITableViewHeaderFooterView>(_ viewType: T.Type) where T: ReusableView {
        register(
            viewType,
            forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier
        )
    }
    
    /// dequeue cell from generic class
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(
            withIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell with type \(T.self)")
        }
        return cell
    }
    
    /// dequeue headerFooterView from generic class
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(for kind: String, at indexPath: IndexPath) -> T where T: ReusableView {
        guard let view = dequeueReusableHeaderFooterView(
            withIdentifier: T.reuseIdentifier
        ) as? T else {
            fatalError("Could not dequeue headerFooter with type \(T.self)")
        }
        return view
    }
}
